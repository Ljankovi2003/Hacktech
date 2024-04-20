// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/chart.dart';
import 'package:flutter_covid_dashboard_ui/navigation_drawer.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/data/data.dart';
import 'package:flutter_covid_dashboard_ui/screens/calling.dart';
import 'package:flutter_covid_dashboard_ui/screens/stats_screen.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'message.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_covid_dashboard_ui/api/notification_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
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

}
class _HomeScreenState extends State<HomeScreen> {
  String _country = 'USA';
  var locationMessage = '';
  String latitude;
  String longitude;
  String Time;

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

    setState(() {
      locationMessage = "Latitude: $lat , Longitude: $long and Time: $time";
    });
  }
  //dialoge for future use
  Future openDialog() => showDialog(
    context: context, 
    builder: (context) =>AlertDialog(
      title: Text("You are about to call help, are you sure?"),
      
      actions: [
        TextButton(
          onPressed: (){}, 
        child: Text("submit")),
        TextButton(
          onPressed: (){}, 
        child: Text("submit"))
      ],
      
    ),
    );
                  
        
      


    


  @override
  Widget build(BuildContext context) {
    
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      
      appBar: AppBar(
          elevation: 0.0,
        backgroundColor: Palette.primaryColor ,
        title: const Text("Home",
        style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Cool_font",
                  ),),


      ),
      drawer:  NavigationDrawer(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(screenHeight),
          
          _buildYourOwnTest(screenHeight),
          _buildText(screenHeight),
          _buildFotter(screenHeight)
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Palette.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
              ],
            ),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Contact emergency services',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                
                Text(
                  locationMessage+" No earthquakes detected near you.",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () async {
                        
                        


                        Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Callingscreen(),
                  ),
                );
                      },
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Call Now',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () async{
                        FlutterPhoneDirectCaller.callNumber("085921191121");
                        getCurrentLocation();
                         Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Messeging(),
                  ),
                );
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Send SMS',
                        style: 
                        
                        Styles.buttonTextStyle,

                        
                      ),
                      textColor: Colors.white,
                      
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
    
  }

  
  

  SliverToBoxAdapter _buildYourOwnTest(double screenHeight) {
    return SliverToBoxAdapter(
       child: InkWell(
          onTap: () {
            getCurrentLocation();
            Navigator.of(context).push(
              
                  MaterialPageRoute(
                    builder: (_) => StatsScreen(),
                  ),
                );
            
                
          },
          child:
           Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.all(10.0),
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAD9FE4), Palette.primaryColor],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset('assets/images/Earthquake.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Click here!',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'To report an\n earthquake',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  maxLines: 2,
                ),
              ],
            )
          ],
        ),
      ),
     ),
    );
    
      
    }
    SliverToBoxAdapter _buildText(double screenHeight) {
    return SliverToBoxAdapter(
       child: Padding(
         padding: const EdgeInsets.only(left:20.0,bottom: 10),
         child: Text(
           "Recent earthquakes",
         style: TextStyle(
                      fontSize: 20.0,
                      height: 1.5,
                      color:const Color(0xFF01579B),
                      
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cool_font",  //You can set your custom height here
                    ) ,),
       )
       
    );}
    SliverToBoxAdapter _buildFotter(double screenHeight){
      return SliverToBoxAdapter(
       child:  SizedBox(
         
         height: 200,
         child: ListView( 
           scrollDirection: Axis.horizontal,
              children: <Widget>[
                
                Container(
                  margin: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(20)),
                  width: 200,
                 
                  child: Column(
                    children: <Widget>[
                      Container(

                        child:ClipRRect( 
                          borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                          child: new Image.asset(
                          'assets/earth/4.11.png',
                          height: 90.0,
                          fit: BoxFit.fill,
                          width: 200,
                        ),)
                         
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                    child: Text(
                    
                    " Magnitude: 6.1\n Location: Mexico \n Date: Nov 4, 11:02",
                    
                    style: TextStyle(
                    fontSize: 15.0,
                    height: 1.5,
                    color:const Color(0xFF01579B),
                    
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cool_font",  //You can set your custom height here
                  ) ,
        ),
      ),
    ),
                    
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(20)),
                  width: 200,
                 
                  child: Column(
                    children: <Widget>[
                      Container(

                        child:ClipRRect( 
                          borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                          child: new Image.asset(
                          'assets/earth/4.11_2.png',
                          height: 90.0,
                          fit: BoxFit.fill,
                          width: 200,
                        ),)
                         
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                    child: Text(
                    
                    " Magnitude: 5.7\n Location: El Salvador \n Date: Nov 4, 05:26 ",
                    
                    style: TextStyle(
                    fontSize: 15.0,
                    height: 1.5,
                    color:const Color(0xFF01579B),
                    
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cool_font",  //You can set your custom height here
                  ) ,
        ),
      ),
    ),
                    
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(20)),
                  width: 200,
                 
                  child: Column(
                    children: <Widget>[
                      Container(

                        child:ClipRRect( 
                          borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                          child: new Image.asset(
                          'assets/earth/3.11.png',
                          height: 90.0,
                          fit: BoxFit.fill,
                          width: 200,
                        ),)
                         
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                    child: Text(
                    
                    " Magnitude: 5.1\n Location: Romania \n Date: Nov 3, 05:50 ",
                    
                    style: TextStyle(
                    fontSize: 15.0,
                    height: 1.5,
                    color:const Color(0xFF01579B),
                    
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cool_font",  //You can set your custom height here
                  ) ,
        ),
      ),
    ),
                    
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(20)),
                  width: 200,
                 
                  child: Column(
                    children: <Widget>[
                      Container(

                        child:ClipRRect( 
                          borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                          child: new Image.asset(
                          'assets/earth/OCT 31.png',
                          height: 90.0,
                          fit: BoxFit.fill,
                          width: 200,
                        ),)
                         
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                    child: Text(
                    
                    " Magnitude: 2.5\n Location: Lugoff, USA \n Date: Oct 31, 02:33",
                    
                    style: TextStyle(
                    fontSize: 15.0,
                    height: 1.5,
                    color:const Color(0xFF01579B),
                    
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cool_font",  //You can set your custom height here
                  ) ,
        ),
      ),
    ),
                    
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(20)),
                  width: 200,
                 
                  child: Column(
                    children: <Widget>[
                      Container(

                        child:ClipRRect( 
                          borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                          child: new Image.asset(
                          'assets/earth/OCT 31.png',
                          height: 90.0,
                          fit: BoxFit.fill,
                          width: 200,
                        ),)
                         
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                    child: Text(
                    
                    " Magnitude: 5.7\n Location: Indonesia \n Date: Feb 13, 09:21",
                    
                    style: TextStyle(
                    fontSize: 15.0,
                    height: 1.5,
                    color:const Color(0xFF01579B),
                    
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cool_font",  //You can set your custom height here
                  ) ,
        ),
      ),
    ),
                    
                    ],
                  ),
                ),
              ],
            ),
       ),
        
      );
    

}


}
