import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/screens/stats_screen.dart';
import 'package:flutter_covid_dashboard_ui/screens/chart.dart';
import 'package:flutter_covid_dashboard_ui/screens/home_screen.dart';



class NavigationDrawer extends StatelessWidget{
  const NavigationDrawer({Key key}) : super(key:key);
  Widget build(BuildContext context)=> Drawer(

    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),



        ],
      ),
    ),
  );
  Widget buildHeader(BuildContext context)=>Container(
    color: Palette.primaryColor,
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
    child: 
                Image.asset(
                  'assets/images/Mala.png',
                  
                  ),
                
  );
   Widget buildMenuItems(BuildContext context)=>Container(
     padding: const EdgeInsets.all(24),
     child: Wrap(
       runSpacing: 16,
      children:[ ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text("Home"),
        onTap: () {
          Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HomeScreen()));
        },
      ),
      ListTile(
        leading: const Icon(Icons.insert_chart),
        title: const Text("Report",),
        onTap: () {
          Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StatsScreen()));
        },
      ),
      ListTile(
        leading: const Icon(Icons.map),
        title: const Text("Test"),
        onTap: () {
          Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MyHomePage()));
        },
      ),
      const Divider(color:Colors.black),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text("Settings"),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.bolt),
        title: const Text("Tutorial"),
        onTap: () {},
      ),

      ]
     ),
   );
}// TODO Implement this library.