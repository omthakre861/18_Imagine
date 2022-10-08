import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  createBooking(
    String collectionName,
    String documentName,
    String collectionBooking,
    String uuid,
    String fullName,
    int age,
    String mobileNo,
    String gender,
    bool paymentStatus,
    String boardingPoint,
    String departingPoint,
    String totalPrice,
    int numberofSeat,
    List<String> seatnolist,
    String busId,
  ) async {
    late String uid;
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentName)
        .collection(collectionBooking)
        .add({
      'uuid': uuid,
      "fullName": fullName,
      "age": age,
      "mobileNo": mobileNo,
      "gender": gender,
      "paymentStatus": paymentStatus,
      "boardingPoint": boardingPoint,
      "departingPoint": departingPoint,
      "totalPrice": totalPrice,
      "seatnolist": seatnolist,
      "busId": busId,
    }).then((value) async {
      // print(value.id);
      uid = value.id;

      List<dynamic> seatlist = await getExistingBusBookingValue();

      for (int i = 0; i < seatnolist.length; i++) {
        int s = int.parse(seatnolist[i]);
        seatlist[s] = {"seatStatus": "B", "user_uid": uuid};
      }
      await updateBooking("seatsList", seatlist);
      print(seatlist);
    });
    return uid;
  }

  updateBooking(field, var newFieldValue) async {
    await FirebaseFirestore.instance
        .collection("Bus")
        .doc("MSRTC-705885")
        .update({field: newFieldValue});
    //print("Fields Updated");
  }
  updatePaymentStatus(String id,field, var newFieldValue) async {
    await FirebaseFirestore.instance
        .collection("booking")
        .doc("wGUYu5TV2Bblpd3llgCqB24bqpk2")
        .collection("all_booking")
        .doc(id)
        .update({field: newFieldValue});
    //print("Fields Updated");
  }

  Future<List<dynamic>> getExistingBusBookingValue() async {
    List<dynamic> getseatList = [];
    await FirebaseFirestore.instance
        .collection('Bus')
        .doc("MSRTC-705885")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        getseatList = documentSnapshot.get("seatsList") as List<dynamic>;
      }
    });
    return getseatList;
  }
}
