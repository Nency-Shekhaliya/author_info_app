import 'package:cloud_firestore/cloud_firestore.dart';

class Firebasedatastore_helper {
  Firebasedatastore_helper._();
  static final Firebasedatastore_helper firebasedatastore_helper =
      Firebasedatastore_helper._();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  insertdata({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore
            .collection("counter")
            .doc("author_counter")
            .get();

    Map<String, dynamic>? counterdata = documentSnapshot.data();

    int authorcounter = counterdata!['counter'];
    int length = counterdata['length'];
    authorcounter++;
    length++;
    await firebaseFirestore
        .collection("Author_Details")
        .doc("$authorcounter")
        .set(data);
    await firebaseFirestore
        .collection("counter")
        .doc("author_counter")
        .update({"counter": authorcounter, "length": length});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> featchallrecord() {
    return firebaseFirestore.collection("Author_Details").snapshots();
  }

  Future<void> updaterecored(
      {required Map<String, dynamic> data, required String id}) async {
    await firebaseFirestore.collection('Author_Details').doc(id).update(data);
  }

  Future<void> deleterecored({required String id}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore
            .collection('counter')
            .doc('author_counter')
            .get();
    Map<String, dynamic>? authorcount = documentSnapshot.data();

    int lengthcount = authorcount!['length'];
    firebaseFirestore.collection("Author_Details").doc(id).delete();
    lengthcount--;
    await firebaseFirestore
        .collection('counter')
        .doc("author_counter")
        .update({"length": lengthcount});
  }
}
