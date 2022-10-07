import 'package:bus_booking_something/pages/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class TripSchedule extends StatefulWidget {
  TripSchedule({Key? key, required this.sourceInput, required this.destInput})
      : super(key: key);
  String sourceInput;
  String destInput;
  @override
  State<TripSchedule> createState() => _TripScheduleState();
}

class _TripScheduleState extends State<TripSchedule> {
  CollectionReference trip =
      FirebaseFirestore.instance.collection('Trip_Schedule');
  List<String> sort = <String>[
    "Departure Time: Earliest First",
    "Departure Time: Latest First",
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
  RangeValues _currentRangeValues = const RangeValues(0, 100);

  static String _valueToString(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
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
              RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 100,
                divisions: 10,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    print("sf");
                  },
                  child: Text("adsf"))
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
          future: trip.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            // if (snapshot.hasData) {
            //   return Text("Document does not exist");
            // }

            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                  physics: const BouncingScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    Timestamp at = data['Arrival Time'];
                    Timestamp dt = data['DepartureTime'];

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Booking(
                            boardingPoint: data["Boarding Points"],
                            droppingPoint: data["Dropping Point"],
                            fromLocation: data["From"],
                            toLocation: data["To "],
                          ),
                        ));
                      },
                      child: Card(
                        margin: EdgeInsets.all(12.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data["Bus Id"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(data["Bus Type"]),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    DateFormat('hh:mm').format(dt.toDate()),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                  Text("------"),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      data["Duration"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            data["Seats Available"].toString()),
                                        Text(" Seats")
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "₹" + data["Fare"].toString(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
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
                  }).toList());
            }
            return Text("loading");
          },
        ),
      ),
    );
  }
}
