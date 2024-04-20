import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/screens/chart.dart';
import 'package:flutter_covid_dashboard_ui/screens/screens.dart';
import 'package:introduction_screen/introduction_screen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List _screens = [
      
      StatsScreen(),
      MyHomePage(),
      
     
      
      
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      
      bottomNavigationBar: SizedBox(
        height: 67, child:
      BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlue[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,

        
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        elevation: 0.0,
        items: [Icons.home, Icons.insert_chart, Icons.map]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: _currentIndex == key
                            ? Colors.blue[600]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(value),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    ),);
  }
}
