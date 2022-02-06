import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/screens/screens.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/data/data.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:flutter_covid_dashboard_ui/screens/screens.dart';
import 'package:flutter_covid_dashboard_ui/screens/home_screen.dart';
import 'package:flutter_covid_dashboard_ui/screens/intro_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_covid_dashboard_ui/api/notification_api.dart';

int initScreen;
List chartData=[0,0];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen= await preferences.getInt("initScreen");
  await preferences.setInt("initScreen", 1);
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);

  runApp(MyApp());
}

var sensorvalue="";
var x;
var y;
void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });
  accelerometerEvents.listen((AccelerometerEvent event) {
      
     sensorvalue=event.toString();
     x=event.x;
     y=event.y;
     
});
  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(milliseconds: 50), (timer) async {
    chartData.add(y / 9.81);
    if (chartData[chartData.length-1]-chartData[chartData.length-2]>=1){
      NotificationApi.showNotification(
          title:"Motion Detected",
          body: "We detected motion, is everything okay?",
          
          
          
        );
      
      
    }

    
    
    if (!(await service.isServiceRunning())) timer.cancel();
    

    service.sendData(
      {"current_date": sensorvalue,
      
      
      
      
      
      
      },
      
    
    );
  });
}
class MyApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nevera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initScreen==0 || initScreen == null? 'onboard' : "home",
      routes: {
        "home" : (context) => BottomNavScreen(),
        "onboard" : (context) => OnboardingScreen() 

      
      },
      
    );
  }
}
