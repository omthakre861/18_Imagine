import 'package:bus_booking_something/pages/trip_sedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController sourceinput = TextEditingController();
  TextEditingController destinationinput = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    dateinput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                    child: Text(
                      "BUS TICKETS",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Container(
                      height: 280,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextField(
                              controller: sourceinput,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.bus_alert),
                                  hintText: "ENTER SOURCE"),
                              onChanged: (value) {
                                sourceinput.value = TextEditingValue(
                                    text: value.toUpperCase(),
                                    selection: sourceinput.selection);
                              }),
                          TextField(
                            controller: destinationinput,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.bus_alert),
                                hintText: "ENTER DESTINATION"),
                          ),
                          TextField(
                            controller:
                                dateinput, //editing controller of this TextField
                            decoration: InputDecoration(
                                icon: Icon(
                                    Icons.calendar_today), //icon of text field
                                labelText: "Enter Date" //label text of field
                                ),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate = DateFormat('EE , MMM dd')
                                    .format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  dateinput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              }
                            },
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            width: _width,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TripSchedule(
                                            sourceInput: sourceinput.text,
                                            destInput: destinationinput.text),
                                      ));
                                },
                                child: Text("SEARCH BUSES")),
                          )
                        ],
                      ),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(10)),
                      //     color: Colors.blue.shade200),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
