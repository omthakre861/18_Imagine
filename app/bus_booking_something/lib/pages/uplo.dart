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
    await db.collection(collection).add(data);
  }

  List addd =
      List.generate(30, (index) => {"seatStatus": "A", "user_uid": "null"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await update("Trip_Schedule", "MSRTC - 470126", {
              "Arrival Time": Timestamp.fromDate(DateTime(2022, 10, 8, 08, 30)),
              "Boarding Points": [
                "05:30 , MUMBAI CENTRAL",
                "05:41 , DADAR EAST",
                "06:46 , PANVEL",
                "06:15,, KHARGHAR"
              ],
              "Bus Id": "MSRTC - 723861",
              "Bus Type": "Semi Luxury (Non AC Seater(2+2))",
              "Date": Timestamp.fromDate(DateTime.now()),
              "Dropping Point": [
                {
                  "coordinate": GeoPoint(13.23, 23.12),
                  "placeName": "09:30 , PUNE",
                }
              ],
              "DepartureTime":
                  Timestamp.fromDate(DateTime(2022, 10, 8, 06, 00)),
              "Duration": "02h 45m",
              "Fare": 328,
              "From": "Mumbai",
              "Seats Available": 10,
              "To ": "PUNE",
              "Rating": 2.6
            });
            // print(addd);
            // counter++;
          },
          child: Text("Send"),
        ),
      ),
    );
  }
}
