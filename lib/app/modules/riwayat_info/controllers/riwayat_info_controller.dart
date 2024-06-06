import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RiwayatInfoController extends GetxController {
  //TODO: Implement RiwayatInfoController
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference riwayatCollection =
      FirebaseFirestore.instance.collection('riwayat');

  Future<DocumentSnapshot> getRiwayatById(String id) async {
    return await riwayatCollection.doc(id).get();
  }

  // Mengambil daftar barang riwayat berdasarkan id riwayat dari Firebase
  Stream<QuerySnapshot> getBarangRiwayat(String docId) {
    return firestore
        .collection('riwayat')
        .doc(docId)
        .collection('barang_riwayat')
        .snapshots();
  }

  String formatCurrency(int amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(amount);
  }

  String formatDate(int tgl) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(tgl);
    String formattedDate =
        DateFormat('dd MMMM yyyy,', 'id_ID').add_jm().format(dateTime);
    return formattedDate;
  }
}
