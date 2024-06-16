import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HistoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxInt selectedMonth = RxInt(0);
  RxInt selectedYear = RxInt(0);

  Future<void> deleteDataRiwayat(String documentId) async {
    try {
      await firestore.collection('riwayat').doc(documentId).delete();
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
    String formattedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    return formattedDate;
  }
  // HistoryController
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
    CollectionReference data = firestore.collection('riwayat');
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
Future<void> printPdf(List<QueryDocumentSnapshot<Object?>> data) async {
  final pdf = pw.Document();

  List<List<String>> tableData = [
    ['Pelanggan', 'Total Harga', 'Tanggal']
  ];

  // Populate table data
  for (var document in data) {
    String pelanggan = document['pelanggan'].toString();
    String totalHarga = formatCurrency(document['total_harga']);
    String tanggal = formatDate(document['tanggal']);
    tableData.add([pelanggan, totalHarga, tanggal]);
  }

  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        pw.Center(
          child: pw.Text(
            'Invoice',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Table.fromTextArray(
          border: pw.TableBorder.all(),
          headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.center,
          headerDecoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(2),
            color: PdfColors.grey300,
          ),
          headerHeight: 40,
          cellHeight: 30,
          data: tableData.map((row) => row.map((cell) => pw.Center(child: pw.Text(cell))).toList()).toList(),
        ),
      ],
    ),
  );

  String timestamp = DateTime.now().toString().replaceAll(' ', '_').replaceAll(':', '-');
  String fileName = 'Invoice_$timestamp.pdf';

  print('Printing requested at: $timestamp');

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
    name: fileName,
  );
}



}