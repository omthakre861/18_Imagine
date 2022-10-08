import 'package:flutter/material.dart';

class FailurePage extends StatelessWidget {
  const FailurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.red,
            size: 80,
          ),
          Text(
            "Ticket Failed",
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ],
      )),
    );
  }
}
