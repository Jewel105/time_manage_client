#!/bin/bash
platform_options=("Android" "iOS" "All")
apk_mode="apk"
env_mode="pro"
ios_mode="adhoc"
apk_file_path="./build/app/outputs/flutter-apk/app-release.apk"
ipa_file_path="./build/ios/ipa/time_manage_client.ipa"
loadly_url="https://api.loadly.io/apiv2/app/upload"

# 自动更新版本号
deal_vsersion(){
  # 是否自动更新版本号
  read -p "更新版本号(默认y)[y/n]: " auto_version
  if [ "${auto_version}" = "n" ]
  then
    return
  fi
  echo -e ""
  # 获取当前版本号
  content=$(sed -n '4p' pubspec.yaml)
  new_sentence="${content/version: /}"
  version=$(echo "$new_sentence" | awk -F '+' '{print $1}')
  major_version=$(echo "$version" | grep -oE '^[0-9]+\.[0-9]+')
  revision_version=$(echo "$version" | grep -oE '[0-9]+$')
  # 将修订版本号转换为整数并加 1
  new_revision=$((revision_version + 1))
  # 组合新的版本号
  new_version="$major_version.$new_revision"
  echo "原始版本号：$version"
  echo "新版本号：$new_version"
  # 提取主版本号、次版本号和修订版本号
  major=$(echo "$new_version" | awk -F '.' '{print $1}')
  minor=$(echo "$new_version" | awk -F '.' '{print $2}')
  revision=$(echo "$new_version" | awk -F '.' '{print $3}')
  number=$(printf "%02d%02d%02d" "$major" "$minor" "$revision")
  # 去除数字字符串前面的多余的0
  number=$(echo "$number" | sed 's/^0*//')
  echo "构建号：$number"
  # 创建一个临时文件并进行替换
  if [ "$(uname)" = "Darwin" ]; then
    # macOS
    sed -i '' 's/'"${content}"'/version: '"${new_version}"'+'"${number}"'/g' pubspec.yaml
  else
    # Windows (Git Bash or Cygwin)
    sed "s/version: ${current_version}/version: ${new_version}+${number}/" pubspec.yaml > pubspec.tmp && mv pubspec.tmp pubspec.yaml
  fi
}

# 发布到UAT环境,上传
publish_uat_android(){
  echo "上传apk到UAT环境"

  response=$(curl -k --progress-bar -X POST "$loadly_url" \
    -F "_api_key=00c267ec2a9938e29636ea58719af9f7" \
    -F "file=@$apk_file_path")

  echo -e "\nAndroid UAT环境，上传成功"
}

publish_uat_ios(){
  echo "上传iOS到UAT环境"
  
 response=$(curl -k --progress-bar -X POST "$loadly_url" \
    -F "_api_key=00c267ec2a9938e29636ea58719af9f7" \
    -F "file=@$ipa_file_path")

  echo -e "\niOS UAT环境，上传成功"
}

build_android(){
  echo -e "开始打包: flutter build ${apk_mode} --release --obfuscate --split-debug-info=./build/symbols --dart-define=APP_ENV=${env_mode}"
  flutter build ${apk_mode} --release --obfuscate --split-debug-info=./build/symbols --dart-define=APP_ENV=${env_mode}
  publish_uat_android
}

build_ios(){
  echo -e "开始打包: flutter build ipa --release --obfuscate --split-debug-info=./build/symbols --export-options-plist=$PWD/ios/${ios_mode}.plist --dart-define=APP_ENV=${env_mode} "
  flutter build ipa --release --obfuscate --split-debug-info=./build/symbols --export-options-plist=$PWD/ios/${ios_mode}.plist --dart-define=APP_ENV=${env_mode}  
  publish_uat_ios
}


# 选择打包ios还是android
select_platform(){
  # 选择平台
  PS3="请选择打包类型: "
  select choice in "${platform_options[@]}"; do
    case $REPLY in
      1)
        echo -e "\n平台:Android   上线平台:${upload_mode}    包类型:${apk_mode}\n"
        build_android
        break
        ;;
      2)
        echo -e "\n平台:iOS   上线平台:${upload_mode}    包类型${ios_mode}\n"
        build_ios
        break
        ;;
      3)
        echo -e "\n平台:iOS,Android   上线平台:${upload_mode}    包类型:${apk_mode},${ios_mode}\n"
        build_android &
        build_ios &
        break
        ;;
      *)
        echo -e "选择出错，请重新选择"
        break
        ;;
    esac
  done
}

deal_vsersion
select_platform

wait
echo "全部完成！"