import 'dart:collection';

import 'package:bus_booking_something/pages/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class TripSchedule extends StatefulWidget {
  TripSchedule({Key? key, required this.sourceInput, required this.destInput})
      : super(key: key);
  String sourceInput;
  String destInput;
  @override
  State<TripSchedule> createState() => _TripScheduleState();
}

class _TripScheduleState extends State<TripSchedule> {
  late Future<QuerySnapshot> trip =
      FirebaseFirestore.instance.collection('Trip_Schedule').get();
  List<String> sort = <String>[
    "Duration : Earliest First",
    "Duration : Latest First",
    "Price: High to Low",
    "Price: Low to High",
    "Seat Availability: High to Low",
    "Seat Availability: Low to High",
    "Popularity: Rating"
  ];
  String sortselect = "";
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: sort[btnValue],
          groupValue: sortselect,
          onChanged: (value) {
            setState(() {
              sortselect = value as String;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SfRangeValues _values = SfRangeValues(450.0, 800.0);

  static String _valueToString(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawerEnableOpenDragGesture: false,
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: Container(
            margin: EdgeInsets.all(9.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 25,
              ),
              Text("Sort by"),
              Container(
                // height: 350,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return addRadioButton(index, sort[index]);
                  },
                ),
              ),
              // Text("Price"),
              // SfRangeSlider(
              //   min: 300.0,
              //   max: 2000.0,
              //   values: _values,
              //   enableTooltip: true,
              //   interval: 400,
              //   showTicks: true,
              //   showLabels: true,
              //   onChanged: (SfRangeValues values) {
              //     setState(() {
              //       _values = values;
              //     });
              //   },
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 140,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black87)),
                        onPressed: () {
                          sortselect = "";
                          setState(() {});
                        },
                        child: Text("Reset")),
                  ),
                  Container(
                    width: 140,
                    child: ElevatedButton(
                        onPressed: () {
                          print("Apply");
                          Navigator.pop(context);
                        },
                        child: Text("Apply")),
                  ),
                ],
              )
            ]),
          ),
        ),
        appBar: AppBar(
          title: Text(widget.sourceInput + " to " + widget.destInput),
          actions: [
            IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                icon: Icon(Icons.filter_alt_outlined))
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: trip,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            // if (snapshot.hasdata)) {
            //   return Text("Document does not exist");
            // }

            if (snapshot.connectionState == ConnectionState.done) {
              List dataa = snapshot.data!.docs;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: dataa.length,
                itemBuilder: (context, index) {
                  // Map<String, dynamic> data =
                  //     document.data()! as Map<String, dynamic>;
                  if (sortselect == sort[0]) {
                    dataa
                        .sort((a, b) => a["Duration"].compareTo(b["Duration"]));
                  }
                  if (sortselect == sort[1]) {
                    dataa
                        .sort((a, b) => b["Duration"].compareTo(a["Duration"]));
                  }
                  if (sortselect == sort[2]) {
                    dataa.sort((a, b) => b["Fare"].compareTo(a["Fare"]));
                  } else if (sortselect == sort[3]) {
                    dataa.sort((a, b) => a["Fare"].compareTo(b["Fare"]));
                  } else if (sortselect == sort[4]) {
                    dataa.sort((a, b) =>
                        b["Seats Available"].compareTo(a["Seats Available"]));
                  } else if (sortselect == sort[5]) {
                    dataa.sort((a, b) =>
                        a["Seats Available"].compareTo(b["Seats Available"]));
                  } else if (sortselect == sort[6]) {
                    dataa.sort((a, b) => b["Rating"].compareTo(a["Rating"]));
                  }

                  Timestamp at = dataa[index]['Arrival Time'];
                  Timestamp dt = dataa[index]['DepartureTime'];

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Booking(
                          boardingPoint: dataa[index]["Boarding Points"],
                          droppingPoint: dataa[index]["Dropping Point"],
                          fromLocation: dataa[index]["From"],
                          toLocation: dataa[index]["To "],
                          busId: dataa[index]["Bus Id"],
                          fare: dataa[index]["Fare"],
                          busType: dataa[index]["Bus Type"],
                        ),
                      ));
                    },
                    child: Card(
                      margin: EdgeInsets.all(12.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dataa[index]["Bus Id"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 25),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.star),
                                        Text(
                                          dataa[index]["Rating"].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(dataa[index]["Bus Type"]),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  DateFormat('hh:mm').format(dt.toDate()),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                                Text("------"),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    dataa[index]["Duration"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(
                                          color: Colors.grey.shade400)),
                                ),
                                Text("------"),
                                Text(
                                  DateFormat('hh:mm').format(at.toDate()),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  margin: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.chair_alt),
                                      Text(" " +
                                          dataa[index]["Seats Available"]
                                              .toString()),
                                      Text(" Seats")
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "₹" + dataa[index]["Fare"].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.pin_drop_outlined),
                                      Text("Live Tracking")
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  margin: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline),
                                      Text("More Details")
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Text("loading");
          },
        ),
      ),
    );
  }
}
