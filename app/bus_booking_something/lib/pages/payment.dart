import 'package:bus_booking_something/pages/failurePage.dart';
import 'package:bus_booking_something/pages/mainpage.dart';
import 'package:bus_booking_something/pages/successPage.dart';
import 'package:bus_booking_something/services/database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';

class Payment extends StatefulWidget {
  Payment(
      {Key? key,
      required this.fromLocation,
      required this.toLocation,
      required this.boardingPoint,
      required this.departingPoint,
      required this.seatNo,
      required this.fullName,
      required this.age,
      required this.totalFare,
      required this.busId,
      required this.busType,
      required this.bookingId})
      : super(key: key);
  String fromLocation;
  String toLocation;
  String boardingPoint;
  String seatNo;
  String departingPoint;
  String fullName;
  String busId;
  String busType;
  int age;
  double totalFare;
  String bookingId;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late var _razorpay;
  var amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Database().updatePaymentStatus(widget.bookingId, "paymentStatus", true);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SucessPage(),
        ),
        (route) => route is MainPage);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FailurePage(),
        ),
        (route) => route is MainPage);

    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  double tollFee = 40.0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 239, 239, 239),
        body: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Payment Details",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              TicketWidget(
                width: 350.0,
                height: 680.0,
                isCornerRounded: true,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  widget.fromLocation,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),

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
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500)),

                              // Text("Banglore"),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(children: [
                              Text(
                                "Bus",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ]),
                            Row(
                              children: [
                                Text(
                                  widget.busId,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Bus Type",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "Seat No",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: Flexible(
                                    child: Text(
                                      widget.busType,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.seatNo,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Boarding Point",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.boardingPoint,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Dropping Point",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.departingPoint,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Traveller",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.fullName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                                Text(
                                  widget.age.toString() + " yrs",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Fare",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "₹ " + widget.totalFare.toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Toll Fee",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "₹ " + tollFee.toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ]),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Grand Total",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "₹  ${widget.totalFare + tollFee}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      InkWell(
                        onTap: () {
                          double total = (widget.totalFare + tollFee)*100;
                          
                          var options = {
                            'key': "rzp_test_agFq9sSxkIlJmD",
                            // amount will be multiple of 100
                            'amount': total.toInt(), //So its pay 500
                            'name': 'OMl',
                            'description': 'Demo',
                            'timeout': 300, // in seconds
                            'prefill': {
                              'contact': '9284708868',
                              'email': 'okthakre861@gmail.com'
                            }
                          };
                          _razorpay.open(options);
                        },
                        child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "Pay " + "₹ ${widget.totalFare + tollFee}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(10), // radius of 10
                                color: Colors
                                    .blueAccent // green as background color
                                )),
                      )
                    ],
                  ),
                ),
              ),
              // ElevatedButton(
              //     child: Text("Pay Amount"),
              //     onPressed: () {
              //       ///Make payment
              //       var options = {
              //         'key': "rzp_test_agFq9sSxkIlJmD",
              //         // amount will be multiple of 100
              //         'amount': (int.parse(amountController.text) * 100)
              //             .toString(), //So its pay 500
              //         'name': 'OMl',
              //         'description': 'Demo',
              //         'timeout': 300, // in seconds
              //         'prefill': {
              //           'contact': '9284708868',
              //           'email': 'okthakre861@gmail.com'
              //         }
              //       };
              //       _razorpay.open(options);
              //     })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }
}
