import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/data/data.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:flutter_covid_dashboard_ui/screens/screens.dart';
import 'package:flutter_covid_dashboard_ui/screens/home_screen.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';

class Messeging extends StatefulWidget {
  

  @override
  _MessegingState createState() => _MessegingState();

}
  
class SMS{
  
  
  
  void _sendSMS(String message, List<String> recipents) async {
 String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
print(_result);}}

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
class _MessegingState extends State<Messeging> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          
          _buildContainer(),
          _buildbox(),
          
          
          _buildHeader6()
        ],
      ),
    );
  }

  

  SliverPadding _buildContainer() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child:  Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: SizeConfig.screenHeight*0.581,
          decoration: BoxDecoration(
            
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/sms.png',
                  height: SizeConfig.screenHeight*0.3841,
                  width: SizeConfig.screenWidth*0.763,
                ),
                
                Text(
                  'Send SMS!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: const Color(0xFF1E88E5),
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
                
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  'Warning:',
                  
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),

                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  'By cliking this button you will text the nearest rescue for earthquakes.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  maxLines: 2,
                ),

              ],
            ),
         
        ),
    ));
  }

  SliverToBoxAdapter _buildbox() {
    return SliverToBoxAdapter(
      child:
      SizedBox (height: SizeConfig.screenHeight * 0.03),
      
    );
  }

  
 



  SliverPadding _buildHeader6() {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        sliver: SliverToBoxAdapter(
          child: GestureDetector(
            onTap: (){
              String message = "This is a test message!";
              List<String> recipents = ["1234567890", "5556787676"];
              SMS()._sendSMS(message, recipents);
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
                  "SEND SMS",
                  style: TextStyle(
                    color: Colors.red,
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

