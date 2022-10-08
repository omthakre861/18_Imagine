import 'package:flutter/material.dart';

class SucessPage extends StatelessWidget {
  const SucessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.green,
            size: 80,
          ),
          Text(
            "Ticket Confirmed",
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ],
      )),
    );
  }
}
