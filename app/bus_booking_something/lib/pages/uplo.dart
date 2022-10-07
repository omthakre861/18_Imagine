import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class uplo extends StatefulWidget {
  uplo({Key? key}) : super(key: key);

  @override
  State<uplo> createState() => _uploState();
}

class _uploState extends State<uplo> {
  static final db = FirebaseFirestore.instance;
  int counter = 0;

  Future<void> update(
      String collection, String document, Map<String, dynamic> data) async {
    await db.collection(collection).doc(document).update(data);
  }

  List addd =
      List.generate(30, (index) => {"seatStatus": "A", "user_uid": "null"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await update("Bus", "MSRTC-705885", {"seatsList": addd});
            // print(addd);
            // counter++;
          },
          child: Text("Send"),
        ),
      ),
    );
  }
}
