import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatetimePickerWidget extends StatefulWidget {
  DateTime dateTime;
  final ValueChanged<DateTime> onChanged;
  String widgetText;

  DatetimePickerWidget({
    required this.dateTime,
    required this.onChanged,
    required this.widgetText,
  });
  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState();
}

class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {
  DateTime dateTime = DateTime.now();

  String getText() {
    if (widget.dateTime == null) {
      return 'Select DateTime';
    } else {
      return DateFormat('dd/MMM/yyyy HH:mm').format(widget.dateTime);
    }
  }
  final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  Widget build(BuildContext context) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.widgetText,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              DateFormat.yMd().add_Hms().format(widget.dateTime),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await pickDateTime(context);

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      widget.dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: widget.dateTime, // ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    return newDate!;
  }

  Future<TimeOfDay> pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: widget.dateTime.hour, minute: 0),
    );
    return newTime!;
  }
}
