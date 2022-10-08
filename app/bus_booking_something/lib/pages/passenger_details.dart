import 'package:bus_booking_something/pages/payment.dart';
import 'package:bus_booking_something/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PassengerDetails extends StatefulWidget {
  PassengerDetails(
      {Key? key,
      required this.fromLocation,
      required this.toLocation,
      required this.boardingPoint,
      required this.departingPoint,
      required this.totalFare,
      required this.busId,
      required this.numberofSeat,
      required this.seatList,
      required this.busType})
      : super(key: key);
  String fromLocation;
  String toLocation;
  String boardingPoint;
  String departingPoint;
  String totalFare;
  String busId;
  int numberofSeat;
  List<String> seatList;
  String busType;

  @override
  State<PassengerDetails> createState() => _PassengerDetailsState();
}

class _PassengerDetailsState extends State<PassengerDetails> {
  String fullName = '';
  String email = '';

  int? age;
  String userPhoneNo = '';
  String bookingID = "";

  final _formKey = GlobalKey<FormState>();

  /// Radio Button Text List
  List<String> gender = <String>["Male", "Female"];
  String genderselect = "";
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: genderselect,
          onChanged: (value) {
            setState(() {
              genderselect = value as String;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  trysubmit() {
    final isvalid = _formKey.currentState!.validate();
    if (isvalid) {
      _formKey.currentState!.save();
      submitform();
    }
  }

  //  Sends data to Cloud Firestore
  submitform() async {
    // var currentuser = FirebaseAuth.instance.currentUser;
    String currentuseruid = "wGUYu5TV2Bblpd3llgCqB24bqpk2";
    // if (currentuser != null) {

    bookingID = await Database().createBooking(
      'booking',
      currentuseruid,
      'all_booking',
      currentuseruid,
      fullName,
      age!,
      userPhoneNo,
      genderselect,
      false,
      widget.boardingPoint,
      widget.departingPoint,
      widget.totalFare,
      widget.numberofSeat,
      widget.seatList,
      widget.busId,
    );

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payment(
            age: age!,
            boardingPoint: widget.boardingPoint,
            departingPoint: widget.departingPoint,
            fromLocation: widget.fromLocation,
            fullName: fullName,
            seatNo: widget.seatList.toString(),
            toLocation: widget.toLocation,
            totalFare: double.parse(widget.totalFare),
            busId: widget.busId,
            busType: widget.busType,
            bookingId: bookingID,
          ),
        ));
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => BlueState(),
    //     ),
    //     (route) => false);Map
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Passenger Details",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            Card(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: 500,
                // height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            widget.fromLocation,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Text(widget.boardingPoint),
                          // Text("Banglore"),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.swipe_right_alt_outlined,
                      size: 45,
                    ),
                    Column(
                      children: [
                        Text(widget.toLocation,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500)),
                        Text(widget.departingPoint),
                        // Text("Banglore"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Form(
                key: _formKey,
                child: Column(children: [
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      height: 190,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Passenger Details",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Full Name'),
                            key: ValueKey('firstname'),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Full Name should not be Empty';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              fullName = value.toString();
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Age'),
                            key: ValueKey('age'),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Age should not be Empty';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              age = int.parse(value.toString());
                            },
                          ),
                          Row(
                            children: [
                              addRadioButton(0, "Male"),
                              addRadioButton(1, "Female"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your ticket info will be sent here",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(hintText: 'Email Address'),
                            key: ValueKey('email'),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Email should not be Empty';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              email = value.toString();
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(hintText: 'Phone Number'),
                            key: ValueKey('userPhoneNo'),
                            validator: (value) {
                              if (value.toString().length != 10) {
                                return 'Invalid Phone Number';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              userPhoneNo = value.toString();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 500,
                    height: 50,
                    margin: EdgeInsets.all(5.0),
                    child: ElevatedButton(
                        onPressed: () {
                          trysubmit();
                        },
                        child: Text(
                          'Proceed to Payment',
                          style: TextStyle(fontSize: 15),
                        )),
                  )
                ])),
          ],
        ),
      ),
    );
  }
}
