import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/api/notification_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:sensors/sensors.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/data/data.dart';
import 'package:flutter_covid_dashboard_ui/screens/stats_screen.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:flutter_covid_dashboard_ui/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_covid_dashboard_ui/navigation_drawer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);
  

 
}


var sensorvalue="";
var x;
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
     print(sensorvalue);
     x=event.x;
     print(x.runtimeType);
});
  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 1), (timer) async {

    
    
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${x}",
    );

    service.sendData(
      {"current_date": sensorvalue,
      
      
      
      
      
      
      },
      
    
    );
  });
}
class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;
  static String stringValue = screenHeight.toString();
  static String stringValue2 = screenWidth.toString();

  void init(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterBackgroundService.initialize(onStart);




    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
  void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  
  
  }


}

class _MyHomePageState extends State<MyHomePage>with WidgetsBindingObserver {
   var locationMessage = '';
  String latitude;
  String longitude;
  String Time;
  var number=0;
  int n=0;
  
  
  

  // function for getting the current location
  // but before that you need to add this permission!
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;
    var time= position.timestamp;

    // passing this to latitude and longitude strings
    latitude = "$lat";
    longitude = "$long";
    Time="$time";
    CollectionReference users= FirebaseFirestore.instance.collection("Reports");
    
    users.add({"Latidude":latitude, "Longtitude":longitude, "Time":time});

    setState(() {
      locationMessage = "Latitude: $lat , Longitude: $long and Time: $time";
    });
  }
  double x, y, z;
  List<LiveData> chartData;
  List<dynamic> Data2;
  var lst=[0.1,0,0,0];
  ChartSeriesController _chartSeriesController;
  bool klik = false;
  //visina i sirina telefona
  int height = 781;
  String width = "392,72";

  @override
  void initState() {
    
    chartData = getChartData();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
    //get the sensor data and set then to the data types

    super.initState();
  }
   
  
  
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();


  }
  
  

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    

    return Scaffold(
            drawer: NavigationDrawer(),
            appBar: AppBar(
            backgroundColor: Palette.primaryColor,
            
            title: const Text('Acceleration/g',)
              
            ),
            body: Center(
                child: Column(children: <Widget>[
              Container(
                  width: 1300,
                  height: SizeConfig.screenHeight * 0.75,
                  child: SfCartesianChart(
                      series: <LineSeries<LiveData, int>>[
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController = controller;
                          },
                          dataSource: chartData,
                          color: Colors.blue,
                          width: 3,
                          xValueMapper: (LiveData sales, _) => sales.time,
                          yValueMapper: (LiveData sales, _) => sales.speed,
                        )
                      ],
                      primaryXAxis: NumericAxis(
                          isVisible: false,
                          majorGridLines: const MajorGridLines(width: 0),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          interval: 5,
                          title: AxisTitle(
                              text: " Time",
                              textStyle: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ))),
                      primaryYAxis: NumericAxis(
                        minimum: -5,
                        maximum: 5,
                          axisLine: const AxisLine(width: 0),
                          majorTickLines: const MajorTickLines(size: 0),
                          interval: 1,
                          title: AxisTitle(
                              textStyle: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ))))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                  height: SizeConfig.screenHeight * 0.08,
                  width: SizeConfig.screenWidth*0.001,),
                  FlatButton.icon(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    onPressed: () {
                      FlutterBackgroundService()
                    .sendData({"action": "setAsForeground"});
                      _timer = Timer.periodic(
                          const Duration(milliseconds: 50), updateDataSource);
                      setState(() {});
                       n=n+1;
                    },
                    color: Colors.lightBlue[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 25,
                    ),
                    label: Text(
                      'Start',
                    ),
                    textColor: Colors.white,
                  ),
                  SizedBox(
                  height: SizeConfig.screenHeight * 0.09,
                  width: SizeConfig.screenWidth*0.1,),
                  FlatButton.icon(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    onPressed: () {
                      
                       
                      if (_timer != null) {
                        _timer.cancel();
                        
                      }
                     
                      if (n>0){

                      Flushbar(
                  title:  "Your data has been saved.",
                  message:  "The data collected from your movement will help us detect earthquakes.",
                  flushbarPosition: FlushbarPosition.TOP,
                  duration:  Duration(seconds: 2),
                  backgroundColor: Colors.blue[600],   
                  margin: EdgeInsets.all(8),
                  icon: Icon(
                    Icons.info_outline,
                    size: 28.0,
                    color: Colors.white,
                    ),
                  borderRadius: 8,           
                )..show(context);
                      }
                    },
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    icon: const Icon(
                      Icons.stop_circle,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Stop',
                    ),
                    textColor: Colors.white,
                  ),
                  SizedBox(
                  height: SizeConfig.screenHeight * 0.04)
                  
                ],
              ),
            ])));
  }

  int time = 199;
  Timer _timer;

  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, (y / 9.81)));
     chartData.removeAt(0);
     print(y);
     
    //adding data to the second list
    lst.add( (y / 9.81));
    lst.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    if (lst[lst.length-1]-lst[lst.length-2]>=1){
      
      getCurrentLocation();
      if (number==0 ){
        Flushbar(
                  title:  "Is everything okay?",
                  message:  "We detected sudden movement, your location has been saved.",
                  flushbarPosition: FlushbarPosition.TOP,
                  duration:  Duration(seconds: 2),
                  backgroundColor: Colors.red[600],   
                  margin: EdgeInsets.all(8),
                  icon: Icon(
                    Icons.info_outline,
                    size: 28.0,
                    color: Colors.white,
                    ),
                  borderRadius: 8,           
                )..show(context);
    

      }
      else{
        NotificationApi.showNotification(
          title:"Motion Detected",
          body: "We detected motion, is everything okay?",
          
          
        );
      }
      // ignore: unrelated_type_equality_checks

    
    
    }
    
        
    
    
  }

  List<dynamic>getData(){
    return <dynamic>[
      LiveData(0,0),
      LiveData(1,0),
      LiveData(2,0),
      LiveData(3,0),
      LiveData(4,0),
      LiveData(5,0),
      LiveData(6,0),
      LiveData(7,0),
      LiveData(8,0),
      LiveData(9,0),
      LiveData(10,0),
    ];

  



    
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0,0),
      LiveData(1,0),
      LiveData(2,0),
      LiveData(3,0),
      LiveData(4,0),
      LiveData(5,0),
      LiveData(6,0),
      LiveData(7,0),
      LiveData(8,0),
      LiveData(9,0),
      LiveData(10,0),
      LiveData(11,0),
      LiveData(12,0),
      LiveData(13,0),
      LiveData(14,0),
      LiveData(15,0),
      LiveData(16,0),
      LiveData(17,0),
      LiveData(18,0),
      LiveData(19,0),
      LiveData(20,0),
      LiveData(21,0),
      LiveData(22,0),
      LiveData(23,0),
      LiveData(24,0),
      LiveData(25,0),
      LiveData(26,0),
      LiveData(27,0),
      LiveData(28,0),
      LiveData(29,0),
      LiveData(30,0),
      LiveData(31,0),
      LiveData(32,0),
      LiveData(33,0),
      LiveData(35,0),
      LiveData(35,0),
      LiveData(36,0),
      LiveData(37,0),
      LiveData(38,0),
      LiveData(39,0),
      LiveData(40,0),
      LiveData(41,0),
      LiveData(42,0),
      LiveData(43,0),
      LiveData(44,0),
      LiveData(45,0),
      LiveData(46,0),
      LiveData(47,0),
      LiveData(48,0),
      LiveData(49,0),
      LiveData(50,0),
      LiveData(51,0),
      LiveData(52,0),
      LiveData(53,0),
      LiveData(54,0),
      LiveData(55,0),
      LiveData(56,0),
      LiveData(57,0),
      LiveData(58,0),
      LiveData(59,0),
      LiveData(60,0),
      LiveData(61,0),
      LiveData(62,0),
      LiveData(63,0),
      LiveData(64,0),
      LiveData(65,0),
      LiveData(66,0),
      LiveData(67,0),
      LiveData(68,0),
      LiveData(69,0),
      LiveData(70,0),
      LiveData(71,0),
      LiveData(72,0),
      LiveData(73,0),
      LiveData(74,0),
      LiveData(75,0),
      LiveData(76,0),
      LiveData(77,0),
      LiveData(78,0),
      LiveData(79,0),
      LiveData(80,0),
      LiveData(81,0),
      LiveData(82,0),
      LiveData(83,0),
      LiveData(84,0),
      LiveData(85,0),
      LiveData(86,0),
      LiveData(87,0),
      LiveData(88,0),
      LiveData(89,0),
      LiveData(90,0),
      LiveData(91,0),
      LiveData(92,0),
      LiveData(93,0),
      LiveData(94,0),
      LiveData(95,0),
      LiveData(96,0),
      LiveData(97,0),
      LiveData(98,0),
      LiveData(99,0),
      LiveData(100,0),
      LiveData(100,0),
      LiveData(101,0),
      LiveData(102,0),
      LiveData(103,0),
      LiveData(104,0),
      LiveData(105,0),
      LiveData(106,0),
      LiveData(107,0),
      LiveData(108,0),
      LiveData(109,0),
      LiveData(110,0),
      LiveData(111,0),
      LiveData(112,0),
      LiveData(113,0),
      LiveData(114,0),
      LiveData(115,0),
      LiveData(116,0),
      LiveData(117,0),
      LiveData(118,0),
      LiveData(119,0),
      LiveData(120,0),
      LiveData(121,0),
      LiveData(122,0),
      LiveData(123,0),
      LiveData(124,0),
      LiveData(125,0),
      LiveData(126,0),
      LiveData(127,0),
      LiveData(128,0),
      LiveData(129,0),
      LiveData(130,0),
      LiveData(131,0),
      LiveData(132,0),
      LiveData(133,0),
      LiveData(135,0),
      LiveData(135,0),
      LiveData(136,0),
      LiveData(137,0),
      LiveData(138,0),
      LiveData(139,0),
      LiveData(140,0),
      LiveData(141,0),
      LiveData(142,0),
      LiveData(143,0),
      LiveData(144,0),
      LiveData(145,0),
      LiveData(146,0),
      LiveData(147,0),
      LiveData(148,0),
      LiveData(149,0),
      LiveData(150,0),
      LiveData(151,0),
      LiveData(152,0),
      LiveData(153,0),
      LiveData(154,0),
      LiveData(155,0),
      LiveData(156,0),
      LiveData(157,0),
      LiveData(158,0),
      LiveData(159,0),
      LiveData(160,0),
      LiveData(161,0),
      LiveData(162,0),
      LiveData(163,0),
      LiveData(164,0),
      LiveData(165,0),
      LiveData(166,0),
      LiveData(167,0),
      LiveData(168,0),
      LiveData(169,0),
      LiveData(170,0),
      LiveData(171,0),
      LiveData(172,0),
      LiveData(173,0),
      LiveData(174,0),
      LiveData(175,0),
      LiveData(176,0),
      LiveData(177,0),
      LiveData(178,0),
      LiveData(179,0),
      LiveData(180,0),
      LiveData(181,0),
      LiveData(182,0),
      LiveData(183,0),
      LiveData(184,0),
      LiveData(185,0),
      LiveData(186,0),
      LiveData(187,0),
      LiveData(188,0),
      LiveData(189,0),
      LiveData(190,0),
      LiveData(191,0),
      LiveData(192,0),
      LiveData(193,0),
      LiveData(194,0),
      LiveData(195,0),
      LiveData(196,0),
      LiveData(197,0),
      LiveData(198,0),
      LiveData(199,0),
      
      
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}
