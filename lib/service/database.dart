import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addDetails(
      Map<String, dynamic> detailsinfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(id)
          .set(detailsinfoMap);
    } catch (e) {
      throw e;
    }
  }

  Future<Stream<QuerySnapshot>> getDetails() async {
    return FirebaseFirestore.instance.collection('user').snapshots();
  }

  Future updateDetails(String id, Map<String, dynamic> updateDetails) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .update(updateDetails);
  }

  Future deleteDetails(String id) async {
    await FirebaseFirestore.instance.collection('user').doc(id).delete();
  }
}
