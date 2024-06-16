import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HistoryInfoController extends GetxController {
  //TODO: Implement HistoryInfoController
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
  //  void printDocument(String id) async {
  //   try {
  //     final DocumentSnapshot snapshot = await getRiwayatById(id);
  //     Printing.layoutPdf(
  //       onLayout: (_) => _buildPdf(snapshot),
  //     );
  //   } catch (e) {
  //     print('Error printing document: $e');
  //   }
  // }
  void printDocument(String id) async {
    try {
      final DocumentSnapshot snapshot = await getRiwayatById(id);
      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          try {
            final Uint8List pdfBytes = await _buildPdf(snapshot);
            return pdfBytes;
          } catch (e) {
            print('Error building PDF: $e');
            throw Exception('Error building PDF: $e');
          }
        },
        name: 'Transaksi-${_generatePdfFileName(snapshot)}.pdf',
      );
    } catch (e) {
      print('Error printing document: $e');
    }
  }
  //this for change name invoice
  String _generatePdfFileName(DocumentSnapshot snapshot) {
  final riwayatData = snapshot.data() as Map<String, dynamic>;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(riwayatData['tanggal']);
  String namaPelanggan = riwayatData['pelanggan'].toString().replaceAll(' ', '_');
  String formattedDate = DateFormat('dd-MMMM-yyyy_HH-mm', 'id_ID').format(dateTime);
  return '$namaPelanggan-$formattedDate';
}

  FutureOr<Uint8List> _buildPdf(DocumentSnapshot snapshot) async {
    final pdf = pw.Document();
    try {
      final riwayatData = snapshot.data() as Map<String, dynamic>;
      final QuerySnapshot querySnapshot =
          await getBarangRiwayat(snapshot.id).first;
      final List<DocumentSnapshot> docs = querySnapshot.docs;

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'SRI REZEKI',
                    style:
                        pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
                  ),
                ),
                pw.Text(
                  'Pelanggan: ${riwayatData['pelanggan']}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 16),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Tanggal: ${formatDate(riwayatData['tanggal'])}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 16),
                ),
                pw.Divider(
                    height: 20,
                    thickness: 8,
                    color: PdfColor.fromInt(0xFFf1f5f9)),
              ],
            ),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(width: 1.0),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 16),
              cellStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.normal, fontSize: 16),
              headerDecoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(2),
                color: PdfColors.grey300,
              ),
              headers: ['Nama Barang', 'Harga Satuan', 'Quantity', 'Total'],
              cellAlignment: pw.Alignment.center,
              data: List<List<dynamic>>.generate(
                docs.length,
                (index) => [
                  docs[index]['nama'],
                  formatCurrency(docs[index]['harga_satuan']),
                  docs[index]['quantity'],
                  formatCurrency(docs[index]['total_harga_barang']),
                ],
              ),
            ),
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 16.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 20),
                  ),
                  pw.Text(
                    formatCurrency(riwayatData['total_harga']),
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      return pdfBytes;
    } catch (e) {
      print('Error building PDF: $e');
      throw Exception('Error building PDF: $e');
    }
  }
}

