import 'package:flutter/material.dart';

class MyBooking extends StatefulWidget {
  MyBooking({Key? key}) : super(key: key);

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("My Booking"),
    );
  }
}