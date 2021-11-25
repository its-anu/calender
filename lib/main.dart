// ignore: import_of_legacy_library_into_null_safe
import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Awesome Calendar Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) =>
                        const MyCalender(),
                  ),
                );
              },
              child: const Text('calender'))),
    );
  }
}

class MyCalender extends StatefulWidget {
  const MyCalender({Key? key}) : super(key: key);

  @override
  _MyCalenderState createState() => _MyCalenderState();
}

class _MyCalenderState extends State<MyCalender> {
  List<DateTime>? selectedDates;
  DateTime? currentMonth = DateTime.now();
  GlobalKey<AwesomeCalendarState> calendarStateKey =
      GlobalKey<AwesomeCalendarState>();
  SelectionMode selectionMode = SelectionMode.single;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        calendarStateKey.currentState!.setCurrentDate(DateTime(
                            currentMonth!.year - 1, currentMonth!.month));
                      },
                    ),
                    Text(DateFormat('yMMMM').format(currentMonth!)),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        calendarStateKey.currentState!.setCurrentDate(DateTime(
                            currentMonth!.year + 1, currentMonth!.month));
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        calendarStateKey.currentState!.setCurrentDate(DateTime(
                            currentMonth!.year, currentMonth!.month - 1));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        calendarStateKey.currentState!.setCurrentDate(DateTime(
                            currentMonth!.year, currentMonth!.month + 1));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: AwesomeCalendar(
              key: calendarStateKey,
              startDate: DateTime(2018),
              endDate: DateTime(2100),
              selectedSingleDate: currentMonth,
              selectedDates: selectedDates,
              selectionMode: selectionMode,
              onPageSelected: (DateTime? start, DateTime? end) {
                setState(() {
                  currentMonth = start;
                });
              },
              dayTileBuilder: CustomDayTileBuilder(),
              // weekdayLabels: widget.weekdayLabels,
            ),
          ),
          ListTile(
            title: const Text(
              'select',
              style: TextStyle(fontSize: 13),
            ),
            leading: Switch(
              value: selectionMode == SelectionMode.range,
              onChanged: (bool value) {
                setState(() {
                  selectionMode =
                      value ? SelectionMode.range : SelectionMode.single;
                  selectedDates = <DateTime>[];
                  calendarStateKey.currentState!.selectedDates = selectedDates;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDayTileBuilder extends DayTileBuilder {
  CustomDayTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date,
      void Function(DateTime datetime)? onTap) {
    return DefaultDayTile(
      date: date,
      onTap: onTap,
      selectedDayColor: Colors.blue,
      currentDayBorderColor: Colors.grey,
    );
  }
}

class DefaultDayTile extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime datetime)? onTap;
  final Color? selectedDayColor;
  final Color? currentDayBorderColor;

  const DefaultDayTile(
      {Key? key,
      required this.date,
      this.onTap,
      this.selectedDayColor,
      this.currentDayBorderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isToday = CalendarHelper.isToday(date);

    final bool daySelected = AwesomeCalendar.of(context)!.isDateSelected(date);

    BoxDecoration? boxDecoration;
    if (daySelected) {
      boxDecoration = BoxDecoration(
        color: selectedDayColor ?? Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      );
    } else if (isToday) {
      boxDecoration = BoxDecoration(
        border: Border.all(
          color:
              currentDayBorderColor ?? Theme.of(context).colorScheme.secondary,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          child: Container(
            height: 32.0,
            decoration: boxDecoration,
            child: Center(
              child: Text(
                '${date.day}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: daySelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          onTap: () => handleTap(context),
          behavior: HitTestBehavior.translucent,
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    final DateTime day = DateTime(date.year, date.month, date.day, 12, 00);
    if (onTap != null) {
      onTap!(day);
    }
    AwesomeCalendar.of(context)!.setSelectedDate(day);
    AwesomeCalendar.of(context)!.setCurrentDate(day);
  }
}
