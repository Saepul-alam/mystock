import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HistoryPenjualanController extends GetxController {
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

  Future<void> printPdf(List<DocumentSnapshot> data) async {
    final pdf = pw.Document();

    Map<String, List<List<dynamic>>> groupedData = {};

    for (var document in data) {
      final querySnapshot = await getBarangRiwayat(document.id).first;
      List<DocumentSnapshot> docs = querySnapshot.docs;
      for (var barang in docs) {
        String pelanggan = document['pelanggan'];
        if (!groupedData.containsKey(pelanggan)) {
          groupedData[pelanggan] = [];
        }
        int quantity = barang['quantity'];
        int hargaSatuan = barang['harga_satuan'];
        groupedData[pelanggan]!.add([
          formatDate(document['tanggal']),
          formatTime(document['tanggal']),
          barang['nama'],
          quantity.toString(),
          formatCurrency(hargaSatuan),
          formatCurrency(hargaSatuan * quantity), // total_harga
        ]);
      }
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Daftar Riwayat',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          for (var pelanggan in groupedData.keys)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Nama Pelanggan: $pelanggan',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                pw.Divider(
                  height: 20,
                  thickness: 2,
                  color: PdfColors.grey,
                ),
                pw.Table.fromTextArray(
                  border: pw.TableBorder.all(),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                  headerDecoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(2),
                    color: PdfColors.grey300,
                  ),
                  headerHeight: 40,
                  cellHeight: 30,
                  data: <List<dynamic>>[
                    [
                      'Tanggal',
                      'Jam',
                      'Nama Barang',
                      'Quantity',
                      'Harga Satuan',
                      'Total Harga'
                    ],
                    ...groupedData[pelanggan]!,
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Total : ${calculateTotalHarga(groupedData[pelanggan]!)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],
            ),
        ],
      ),
    );

    String timestamp =
        DateTime.now().toString().replaceAll(' ', '_').replaceAll(':', '-');
    String fileName = 'Daftar_Riwayat_$timestamp.pdf';

    print('Printing requested at: $timestamp');

    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: fileName,
      );
    } catch (e) {
      print('Error printing PDF: $e');

      Get.snackbar(
        'Error',
        'Failed to print: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  String calculateTotalHarga(List<List<dynamic>> data) {
    int total = 0;
    for (var row in data) {
      total += int.tryParse(row[5]
              .replaceAll('Rp', '')
              .replaceAll('.', '')
              .replaceAll(',', '')
              .trim()) ??
          0;
    }
    return formatCurrency(total);
  }

  Stream<QuerySnapshot<Object?>> getBarangRiwayat(String docId) {
    return firestore
        .collection('riwayat')
        .doc(docId)
        .collection('barang_riwayat')
        .snapshots();
  }
}
