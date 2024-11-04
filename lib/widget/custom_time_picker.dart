import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datat_time_picker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/utils/index.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({
    super.key,
    required this.typeCode,
    required this.selectedDates,
  });
  final String typeCode; // 1: 日, 2: 周, 3: 月, 4: 年
  final ValueNotifier<List<DateTime>> selectedDates;
  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  DateTime _selectedDate = DateTime.now();
  late CommonPickerModel pickerModel;

  @override
  void initState() {
    super.initState();
    _calcRangeDate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initPicker();
  }

  @override
  void didUpdateWidget(CustomTimePicker old) {
    super.didUpdateWidget(old);
    _initPicker();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calcRangeDate();
    });
  }

  _calcRangeDate() {
    switch (widget.typeCode) {
      case 'day':
        List<DateTime> list = <DateTime>[
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,
              23, 59, 59),
        ];
        widget.selectedDates.value = list;
        break;
      case 'week':
        widget.selectedDates.value = calcWeekDays(_selectedDate);
        break;
      case 'month':
        DateTime currentMonth =
            DateTime(_selectedDate.year, _selectedDate.month);
        DateTime nextMonth =
            DateTime(_selectedDate.year, _selectedDate.month + 1);
        DateTime lastDayOfMonth = nextMonth.subtract(Duration(days: 1));
        List<DateTime> list = <DateTime>[
          currentMonth,
          DateTime(lastDayOfMonth.year, lastDayOfMonth.month,
              lastDayOfMonth.day, 23, 59, 59),
        ];
        widget.selectedDates.value = list;
        break;
      case 'year':
        DateTime currentYear = DateTime(_selectedDate.year);
        DateTime nextYear = DateTime(_selectedDate.year + 1);
        DateTime lastDayOfYear = nextYear.subtract(Duration(days: 1));
        List<DateTime> list = <DateTime>[
          currentYear,
          DateTime(lastDayOfYear.year, lastDayOfYear.month, lastDayOfYear.day,
              23, 59, 59),
        ];
        widget.selectedDates.value = list;
        break;
      default:
        List<DateTime> list = <DateTime>[
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,
              23, 59, 59),
        ];
        widget.selectedDates.value = list;
        break;
    }
  }

  _initPicker() async {
    Locale currentLocale = Localizations.localeOf(context);
    switch (widget.typeCode) {
      case 'day': // 选日
        pickerModel = DatePickerModel(
          currentTime: _selectedDate,
          minTime: DateTime.now().subtract(const Duration(days: 3650)),
          maxTime: DateTime.now(),
          locale: currentLocale.languageCode == 'zh'
              ? LocaleType.zh
              : LocaleType.en,
        );
        break;
      case 'week': // 周
        pickerModel = WeekPicker(
          currentTime: _selectedDate,
          minTime: DateTime.now().subtract(const Duration(days: 3650)),
          maxTime: DateTime.now(),
          locale: currentLocale.languageCode == 'zh'
              ? LocaleType.zh
              : LocaleType.en,
        );
        break;
      case 'month': // 月
        pickerModel = MonthPicker(
          currentTime: _selectedDate,
          minTime: DateTime.now().subtract(const Duration(days: 3650)),
          maxTime: DateTime.now(),
          locale: currentLocale.languageCode == 'zh'
              ? LocaleType.zh
              : LocaleType.en,
        );
        break;
      case 'year': // 年
        pickerModel = YearPicker(
          currentTime: _selectedDate,
          minTime: DateTime.now().subtract(const Duration(days: 3650)),
          maxTime: DateTime.now(),
          locale: currentLocale.languageCode == 'zh'
              ? LocaleType.zh
              : LocaleType.en,
        );
        break;
      default:
        pickerModel = DatePickerModel(
          currentTime: _selectedDate,
          minTime: DateTime.now().subtract(const Duration(days: 3650)),
          maxTime: DateTime.now(),
          locale: currentLocale.languageCode == 'zh'
              ? LocaleType.zh
              : LocaleType.en,
        );
        return;
    }
  }

  _showSelection() async {
    DateTime? d = await DatePicker.showPicker(
      context,
      pickerModel: pickerModel,
      theme: datat_time_picker.DatePickerTheme(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        cancelStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        doneStyle: TextStyle(color: Theme.of(context).primaryColor),
        itemStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
      ),
    );
    if (d != null) {
      _selectedDate = d;
      _calcRangeDate();
      setState(() {});
    }
  }

  String get dayText => StringUtil.dateTimeFormat(
        context,
        time: _selectedDate.millisecondsSinceEpoch,
        format: DateFormat.yMMMd,
      );

  String get monthText => StringUtil.dateTimeFormat(
        context,
        time: _selectedDate.millisecondsSinceEpoch,
        format: DateFormat.yMMMM,
      );

  String get yearText => StringUtil.dateTimeFormat(
        context,
        time: _selectedDate.millisecondsSinceEpoch,
        format: DateFormat.y,
      );

  String get weekText {
    List<DateTime> list = calcWeekDays(_selectedDate);

    List<String> week = list
        .map(
          (DateTime date) => StringUtil.dateTimeFormat(context,
              time: date.millisecondsSinceEpoch, format: DateFormat.yMMMd),
        )
        .toList();
    return week.join('-');
  }

  String get text {
    switch (widget.typeCode) {
      case 'day':
        return dayText;
      case 'week':
        return weekText;
      case 'month':
        return monthText;
      case 'year':
        return yearText;
      default:
        return dayText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSelection,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(text),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

int calcDateCount(int year, int month) {
  List<int> leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];
  if (leapYearMonths.contains(month)) {
    return 31;
  } else if (month == 2) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return 29;
    }
    return 28;
  }
  return 30;
}

List<DateTime> calcWeekDays(DateTime dateTime) {
  int offset = dateTime.weekday - 1;
  DateTime start = dateTime.subtract(Duration(days: offset));
  DateTime startTime = DateTime(start.year, start.month, start.day);
  DateTime end = startTime.add(const Duration(days: 6));
  DateTime endTime = DateTime(end.year, end.month, end.day, 23, 59, 59);
  return <DateTime>[startTime, endTime];
}

class WeekPicker extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;
  WeekPicker({
    required DateTime currentTime,
    required LocaleType locale,
    DateTime? maxTime,
    DateTime? minTime,
  }) : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    this.currentTime = currentTime;
    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();

    setLeftIndex(this.currentTime.year - this.minTime.year);
    setMiddleIndex(this.currentTime.month - 1);
    setRightIndex(_calcWeekIndex(this.currentTime.day));
  }

  void _fillLeftLists() {
    leftList =
        List<String>.generate(maxTime.year - minTime.year + 1, (int index) {
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  void _fillMiddleLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    middleList = List<String>.generate(maxMonth - minMonth + 1, (int index) {
      return _localeMonth(minMonth + index);
    });
  }

  void _fillRightLists() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    rightList = <String>[];
    int firstWeekDay =
        DateTime(currentTime.year, currentTime.month, minDay).weekday;
    int endDay = minDay + 7 - firstWeekDay;
    if (endDay > maxDay) {
      endDay = maxDay;
    }
    if (endDay - minDay < 6) {
      rightList.add('···-$endDay${_localeDay()}');
    } else {
      rightList.add('$minDay-$endDay${_localeDay()}');
    }
    minDay = minDay + 8 - firstWeekDay;
    while (minDay <= maxDay) {
      int endDay = minDay + 6;
      if (endDay > maxDay) {
        endDay = maxDay;
      }
      if (endDay - minDay < 6) {
        rightList.add('$minDay-···${_localeDay()}');
      } else {
        rightList.add('$minDay-$endDay${_localeDay()}');
      }
      minDay = minDay + 7;
    }
  }

  int _calcWeekIndex(int currentDay) {
    int minDay = _minDayOfCurrentMonth();
    int index = 0;
    int firstWeekDay =
        DateTime(currentTime.year, currentTime.month, minDay).weekday;
    minDay = minDay + 8 - firstWeekDay;
    while (minDay <= currentDay) {
      index++;
      minDay = minDay + 7;
    }
    return index;
  }

  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime.year &&
            currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime.year == minTime.year &&
            currentTime.month == minTime.month
        ? minTime.day
        : 1;
  }

  int _maxMonthOfCurrentYear() {
    return currentTime.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime.year == minTime.year ? minTime.month : 1;
  }

  String _localeYear() {
    if (locale == LocaleType.zh) {
      return '年';
    } else {
      return '';
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      List<String> monthStrings =
          i18nObjInLocale(locale)['monthLong'] as List<String>;
      return monthStrings[month - 1];
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh) {
      return '日';
    } else {
      return '';
    }
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            )
          : DateTime(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            );
    } else {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              currentTime.day,
            )
          : DateTime(
              destYear,
              currentTime.month,
              currentTime.day,
            );
    }
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    _fillRightLists();
    minMonth = _minMonthOfCurrentYear();
    setMiddleIndex(currentTime.month - minMonth);
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          )
        : DateTime(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillRightLists();
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minDay = _minDayOfCurrentMonth(); // 1
    currentTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            minDay + index * 7,
          )
        : DateTime(currentTime.year, currentTime.month, minDay + index * 7);
  }

  @override
  List<int> layoutProportions() {
    return <int>[1, 1, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day)
        : DateTime(currentTime.year, currentTime.month, currentTime.day);
  }
}

class MonthPicker extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;
  MonthPicker({
    required DateTime currentTime,
    required LocaleType locale,
    DateTime? maxTime,
    DateTime? minTime,
  }) : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    this.currentTime = currentTime;
    _fillLeftLists();
    _fillMiddleLists();

    setLeftIndex(this.currentTime.year - this.minTime.year);
    setMiddleIndex(this.currentTime.month - 1);
    setRightIndex(0);
  }

  void _fillLeftLists() {
    leftList =
        List<String>.generate(maxTime.year - minTime.year + 1, (int index) {
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  void _fillMiddleLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    middleList = List<String>.generate(maxMonth - minMonth + 1, (int index) {
      return _localeMonth(minMonth + index);
    });
  }

  int _maxMonthOfCurrentYear() {
    return currentTime.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime.year == minTime.year ? minTime.month : 1;
  }

  String _localeYear() {
    if (locale == LocaleType.zh) {
      return '年';
    } else {
      return '';
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      List<String> monthStrings =
          i18nObjInLocale(locale)['monthLong'] as List<String>;
      return monthStrings[month - 1];
    }
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            )
          : DateTime(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            );
    } else {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              currentTime.day,
            )
          : DateTime(
              destYear,
              currentTime.month,
              currentTime.day,
            );
    }
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    minMonth = _minMonthOfCurrentYear();
    setMiddleIndex(currentTime.month - minMonth);
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          )
        : DateTime(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }
  }

  @override
  List<int> layoutProportions() {
    return <int>[1, 1, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month)
        : DateTime(currentTime.year, currentTime.month);
  }
}

class YearPicker extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;
  YearPicker({
    required DateTime currentTime,
    required LocaleType locale,
    DateTime? maxTime,
    DateTime? minTime,
  }) : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    this.currentTime = currentTime;
    _fillLeftLists();

    setLeftIndex(this.currentTime.year - this.minTime.year);
    setMiddleIndex(0);
    setRightIndex(0);
  }

  void _fillLeftLists() {
    leftList =
        List<String>.generate(maxTime.year - minTime.year + 1, (int index) {
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  String _localeYear() {
    if (locale == LocaleType.zh) {
      return '年';
    } else {
      return '';
    }
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  List<int> layoutProportions() {
    return <int>[1, 0, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year)
        : DateTime(currentTime.year);
  }
}
