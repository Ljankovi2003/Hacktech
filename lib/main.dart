import 'dart:io';

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
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

String latitude;
String longitude;
String Time;
var number=0;
int n=0;
int initScreen;
List <double>chartData=[0,9.81,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
List <double>Firedata=[];


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen= await preferences.getInt("initScreen");
  await preferences.setInt("initScreen", 1);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterBackgroundService.initialize(onStart);
  



  runApp(MyApp());
}

Future<String> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId;
     // unique ID on Android
  }
  
}



var sensorvalue="";
var x;
var y;
void onStart() async{
  
  
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  Firebase.initializeApp();
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
    Firebase.initializeApp();
    chartData.add(y / 9.81);
    if (chartData[chartData.length-1]-chartData[chartData.length-2]>=1){
      getCurrentLocation();
      
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
void getCurrentLocation() async {
  String deviceId = await _getId();
  Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;
    var time= position.timestamp;
    Firedata=chartData.sublist(chartData.length-50,chartData.length);

    // passing this to latitude and longitude strings
    latitude = "$lat";
    longitude = "$long";
    Time="$time";
    CollectionReference users= FirebaseFirestore.instance.collection("NEW");
    users
    .doc(deviceId)
    .set({"Latidude":latitude, "Longtitude":longitude, "Time":time,"Data":Firedata.toList()});

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
        "home" : (context) => HomeScreen(),
        "onboard" : (context) => OnboardingScreen() 

      
      },
      
    );
  }
}
