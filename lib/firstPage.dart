import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import './secondPage.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  // static const String CHANNEL = "myFlutter/getstats";
  // static const platform = const MethodChannel(CHANNEL);
  int _batteryLevel;
  double progressValue = 40;
Future<void> _getBatteryLevel() async {
    int batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = result;
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Usage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _buildCard(),
                  Text(_batteryLevel.toString()+" %"),
                  Text(
                    "Hours Used",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Updated 2 mins ago",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SecondPage(),
                    ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Manage Limit'), Icon(Icons.arrow_right)],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _buildCard() {
    return Container(
      height: 200,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: Color.fromARGB(30, 0, 169, 181),
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: _batteryLevel != null ? _batteryLevel.toDouble() : 10,
              cornerStyle: CornerStyle.bothCurve,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
            )
          ],
        ),
      ]),
    );
  }
}
