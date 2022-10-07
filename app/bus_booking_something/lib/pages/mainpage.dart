// ignore_for_file: prefer_const_constructors


import 'package:bus_booking_something/pages/home.dart';
import 'package:bus_booking_something/pages/mybooking.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = <Widget>[HomePage(),MyBooking()];
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: screens,
        onPageChanged: (index) => setState(() => currentIndex = index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Bookings',
          ),
          
        ],
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
          _controller.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }),
      ),
    );
  }
}
