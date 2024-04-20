import 'dart:ui';
import 'package:sizer/sizer.dart';
import 'package:flutter_covid_dashboard_ui/navigation_drawer.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/data/data.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:flutter_covid_dashboard_ui/screens/screens.dart';
import 'package:flutter_covid_dashboard_ui/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
  
  
}





class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  final myController = TextEditingController();
   var locationMessage = '';
  String latitude;
  String longitude;
  String Time;
  int n=0;

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
    CollectionReference users= FirebaseFirestore.instance.collection("Locations");
    users.add({"Latidude":latitude, "Longtitude":longitude, "Time":time});

    setState(() {
      locationMessage = "Latitude: $lat , Longitude: $long and Time: $time";
    });
  }


  TabController _tabController;
  TabController _tabController2;
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
  


  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth/100;
    blockSizeVertical = screenHeight/100;
    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal)/100;
    safeBlockVertical = (screenHeight - _safeAreaVertical)/100;
    
     
    
  }

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _tabController2 = TabController(vsync: this, length: 4);
  }



  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Palette.primaryColor,
          drawer: NavigationDrawer(),
          appBar: AppBar(backgroundColor: Palette.primaryColor,title: const Text("Form",
        style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Cool_font",
                  ),),
            elevation: 0.0,),
          body: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              _buildHeader(),
              _buildHeader2(),
              _buildRegionTabBar(),
              _buildHeader3(),
              _buildRegionTabBar2(),
              _buildHeader4(),
              _buildHeader5(),
              _buildHeader6(),
               
            ],
          ),
        );
      });
    }
  

  SliverPadding _buildHeader() {
    
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical:MediaQuery.of(context).size.height*0.0192,
        horizontal:MediaQuery.of(context).size.width*0.0382 ),
      sliver: SliverToBoxAdapter(
        
      ),
    );
  }

  SliverPadding _buildHeader2() {
    return SliverPadding(
      padding:  EdgeInsets.symmetric(
        vertical:MediaQuery.of(context).size.height*0.0222,
        horizontal:MediaQuery.of(context).size.width*0.0382 ),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Earthquake strength',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRegionTabBar() {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 5,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          height: MediaQuery.of(context).size.height*0.064,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight:MediaQuery.of(context).size.height* 0.05121,
              indicatorColor: Colors.white,
            ),
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Text('1'),
              Text('2'),
              Text('3'),
              Text('4'),
              Text('5'),
            ],
            onTap: (index) {},
          ),
        ),
      ),
    );
  }

  SliverPadding _buildHeader3() {
    return SliverPadding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.015),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Time since Earthquake',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRegionTabBar2() {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 4,
        child: Container(
          margin:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*0.0256),
          height: MediaQuery.of(context).size.height*0.064,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            controller: _tabController2,
            indicator: BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: MediaQuery.of(context).size.height*0.0512,
              indicatorColor: Colors.white,
            ),
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Text('<10m'),
              Text('<30m'),
              Text('<60m'),
              Text('More'),
            ],
            onTap: (index) {},
          ),
        ),
      ),
    );
  }

  SliverPadding _buildHeader4() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: MediaQuery.of(context).size.height* 0.0228),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Descirbe the earthquake:',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader5() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        height: MediaQuery.of(context).size.height*0.163649,
        padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: TextField(
          controller: myController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Enter a short description",
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }
 

  SliverPadding _buildHeader6() {
    return SliverPadding(
        padding:  EdgeInsets.symmetric(horizontal: 2.w , vertical:  MediaQuery.of(context).size.height*0.0554),
        sliver: SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () {
              n=n+1;
              myController.clear();
              _tabController.animateTo(0);
              _tabController2.animateTo(0);
              getCurrentLocation();
              if (n<5){
              Flushbar(
                  title:  "Your location has been saved ",
                  message:  "We saved your location in case you need help",
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

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  duration: Duration(seconds: 1),
                  content: Container(
                    height: MediaQuery.of(context).size.height*0.07658,
                    child: Text(
                      "Data saved",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        
                        fontWeight: FontWeight.bold,
                        color: Palette.primaryColor
                        ),
                    ),
                  ),
                ),
              );
              }
              else{
                Flushbar(
                  title:  "To many requests",
                  message:  "Your reported to many earthquakes in a small period of time",
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
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width * .85,
              height: 60,
              child: Center(
                child: Text(
                  "SAVE DATA",
                  style: TextStyle(
                    color: Palette.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
