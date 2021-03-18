import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  TimeOfDay _time = TimeOfDay(hour: 7);
  int _hour;
  String _hourText;

  void _selectTime() async {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        print('confirm ${date.hour}');
        setState(() {
          _hour = date.hour;
        });
      },
      currentTime: DateTime.now(),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Daily Limit'),
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _hour == null
                  ? "Select a duration"
                  : _hour.toString() + " hours selected",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 34),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('SELECT TIME'),
            ),
            SizedBox(height: 34),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.check),
            )
          ],
        ),
      ),
    );
  }
}
