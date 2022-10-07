import 'package:bus_booking_something/pages/passenger_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Booking extends StatefulWidget {
  Booking(
      {Key? key,
      required this.boardingPoint,
      required this.droppingPoint,
      required this.fromLocation,
      required this.toLocation})
      : super(key: key);
  List<dynamic> boardingPoint;
  List<dynamic> droppingPoint;
  String fromLocation;
  String toLocation;

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List<dynamic> seatavail = [{}];

  @override
  void initState() {
    // TODO: implement initState
    getseatavailability();
    super.initState();
  }

  String boardingPoint = "";
  String departingPoint = "";
  String totalFare = "";

  int seatcount = 0;
  double fare = 800;
  double totalprice = 0;

  int _activeCurrentStep = 0;

  // Here we have created list of steps
  // that are required to complete the form
  List<int> blank = [
    1,
    2,
    6,
    7,
  ];

  List<int> seatavailabiltychart = [];
  Future<void> getseatavailability() async {
    await FirebaseFirestore.instance
        .collection('Bus')
        .doc("MSRTC-705885")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        seatavail = data["seatsList"] as List<dynamic>;
      }
    });

    if (seatavail.isNotEmpty) {
      seatavailabiltychart = List.generate(seatavail.length, (index) {
        if (seatavail[index]["seatStatus"] == "A") {
          return 0;
        } else
          return 1;
      });
      print(seatavailabiltychart);
    }
  }

  Widget busSeatlayout() {
    return Container(
        height: 500,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerRight,
              child: Image(
                width: 45,
                image: AssetImage("asset/steeringwheel.png"),
              ),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: seatavailabiltychart.length,
              itemBuilder: (context, index) {
                if ((index - 2) % 5 != 0)
                  return InkWell(
                      onTap: () async {
                        if (seatavailabiltychart[index] != 1) {
                          if (seatavailabiltychart[index] == 0) {
                            setState(() {
                              seatavailabiltychart[index] = 2;
                              seatcount++;
                              totalprice = seatcount * fare;
                            });
                          } else {
                            setState(() {
                              seatavailabiltychart[index] = 0;
                              seatcount--;
                              totalprice = seatcount * fare;
                            });
                          }
                        }
                      },
                      child: seatavailabiltychart[index] == 1
                          ? Icon(
                              Icons.chair_rounded,
                              size: 45,
                            )
                          : seatavailabiltychart[index] == 2
                              ? Icon(
                                  Icons.chair_rounded,
                                  color: Colors.blue,
                                  size: 45,
                                )
                              : Icon(
                                  Icons.chair_outlined,
                                  size: 45,
                                ));
                return SizedBox();
              },
            ),
          ],
        ));
  }

  Widget boardingList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.boardingPoint.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            boardingPoint = widget.boardingPoint[index];
            _activeCurrentStep += 1;
            setState(() {});
          },
          child: Card(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(5.0),
              height: 50,
              child: Text(
                widget.boardingPoint[index].toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget departingList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.droppingPoint.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            departingPoint = widget.droppingPoint[index];
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PassengerDetails(
                      fromLocation: widget.fromLocation,
                      toLocation: widget.toLocation,
                      boardingPoint: boardingPoint,
                      departingPoint: departingPoint,
                      totalFare: totalFare),
                ));
          },
          child: Card(
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5.0),
                height: 50,
                child: Text(
                  widget.droppingPoint[index].toString(),
                  style: TextStyle(fontSize: 20),
                )),
          ),
        );
      },
    );
  }

  List<Step> stepList() => [
        Step(
            state: _activeCurrentStep <= 0
                ? StepState.editing
                : StepState.complete,
            isActive: _activeCurrentStep >= 0,
            title: const Text('Seat \nSelection'),
            content: busSeatlayout()),

        Step(
            state: _activeCurrentStep <= 1
                ? StepState.editing
                : StepState.complete,
            isActive: _activeCurrentStep >= 1,
            title: const Text('Boarding \nPoint'),
            content: boardingList()),

        // This is Step3 here we will display all the details
        // that are entered by the user
        Step(
            state: StepState.complete,
            isActive: _activeCurrentStep >= 2,
            title: const Text('Dropping \nPoint'),
            content: departingList())
      ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Here we have initialized the stepper widget
        body: Column(
          children: [
            Expanded(
              child: Stepper(
                type: StepperType.horizontal,
                controlsBuilder: (context, onStepContinue) {
                  return Container(
                    height: 150,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (_activeCurrentStep == 0) ...[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Text(
                                        seatcount.toString(),
                                        style: TextStyle(fontSize: 28),
                                      ),
                                      Text("Seats")
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "₹ " + totalprice.toString(),
                                        style: TextStyle(fontSize: 28),
                                      ),
                                      Text("Total Price")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 300,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  _activeCurrentStep += 1;
                                  setState(() {});
                                  onStepContinue.onStepContinue;
                                },
                                child: const Text(
                                  'Proceed',
                                ),
                              ),
                            ),
                          ]
                        ]),
                  );
                },

                currentStep: _activeCurrentStep,
                steps: stepList(),

                // onStepContinue takes us to the next step
                onStepContinue: () {
                  if (_activeCurrentStep < (stepList().length - 1)) {
                    setState(() {
                      _activeCurrentStep += 1;
                    });
                  }
                },

                // onStepCancel takes us to the previous step
                onStepCancel: () {
                  if (_activeCurrentStep == 0) {
                    return;
                  }

                  setState(() {
                    _activeCurrentStep -= 1;
                  });
                },

                // onStepTap allows to directly click on the particular step we want
                onStepTapped: (int index) {
                  setState(() {
                    _activeCurrentStep = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
