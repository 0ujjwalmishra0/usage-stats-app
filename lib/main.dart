import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'firstPage.dart';
const myTask = "syncWithTheBackEnd";

void main() {
    Workmanager.initialize(callbackDispatcher,isInDebugMode: true);
  Workmanager.registerOneOffTask(
    "1",
    myTask, //This is the value that will be returned in the callbackDispatcher
    initialDelay: Duration(minutes: 5),
    // constraints: WorkManagerConstraintConfig(
    //   requiresCharging: true,
    //   networkType: NetworkType.connected,
    // ),
  );
  runApp(MyApp());
}
void callbackDispatcher() {
  Workmanager.executeTask((task,inputData) {
    switch (task) {
      case myTask:
        print("this method was called from native!");
        break;
      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }

    //Return true when the task executed successfully or not
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirstPage(),
    );
  }
}

