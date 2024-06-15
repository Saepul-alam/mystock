import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> streamDataRiwayat() {
    CollectionReference data = firestore.collection('riwayat');
    return data.orderBy('tanggal', descending: true).snapshots();
  }




   // Stream untuk mendapatkan data riwayat dengan filter tanggal
  Stream<QuerySnapshot> streamDataRiwayatFiltered(DateTime date) {
    var startDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
    var endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    CollectionReference data = firestore.collection('riwayat');
    return data
        .where('tanggal', isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch)
        .where('tanggal', isLessThanOrEqualTo: endDate.millisecondsSinceEpoch)
        .orderBy('tanggal', descending: true)
        .snapshots();
  }


  

  String formatCurrency(int amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(amount);
  }

  String formatDate(int tgl) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(tgl);
    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    return formattedDate;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
