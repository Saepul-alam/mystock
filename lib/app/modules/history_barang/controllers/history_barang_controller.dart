import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryBarangController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxInt selectedMonth = RxInt(0);
  RxInt selectedYear = RxInt(0);

  Future<void> deleteDataRiwayat(String documentId) async {
    try {
      await firestore.collection('riwayat_barang').doc(documentId).delete();
      print('Document $documentId deleted');
    } catch (e) {
      print('Error deleting document: $e');
    }
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

  String formatTime(int tgl) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(tgl);
    String formattedTime =
        DateFormat('HH:mm', 'id_ID').format(dateTime); // Format jam
    return formattedTime;
  }

  void resetFilter() {
    selectedDate.value = null;
    selectedMonth.value = 0;
    selectedYear.value = 0;
  }

  void filterdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate.value = picked;
      selectedMonth.value = picked.month;
      selectedYear.value = picked.year;
    }
  }

  Stream<QuerySnapshot<Object?>> streamDataRiwayat() {
    CollectionReference data = firestore.collection('riwayat_stok');
    Query query = data.orderBy('tanggal', descending: true);

    if (selectedDate.value != null) {
      int startOfDay = DateTime(selectedDate.value!.year,
              selectedDate.value!.month, selectedDate.value!.day)
          .millisecondsSinceEpoch;
      int endOfDay = DateTime(selectedDate.value!.year,
              selectedDate.value!.month, selectedDate.value!.day + 1)
          .millisecondsSinceEpoch;
      query = query
          .where('tanggal', isGreaterThanOrEqualTo: startOfDay)
          .where('tanggal', isLessThan: endOfDay);
    } else if (selectedMonth.value != 0 && selectedYear.value != 0) {
      int startOfMonth = DateTime(selectedYear.value, selectedMonth.value, 1)
          .millisecondsSinceEpoch;
      int endOfMonth = DateTime(selectedYear.value, selectedMonth.value + 1, 1)
          .millisecondsSinceEpoch;
      query = query
          .where('tanggal', isGreaterThanOrEqualTo: startOfMonth)
          .where('tanggal', isLessThan: endOfMonth);
    }

    return query.snapshots();
  }

  Stream<QuerySnapshot<Object?>> getBarangRiwayat(String docId) {
    return firestore
        .collection('riwayat')
        .doc(docId)
        .collection('barang_riwayat')
        .snapshots();
  }
}
