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
   void printDocument(String id) async {
    try {
      final DocumentSnapshot snapshot = await getRiwayatById(id);
      Printing.layoutPdf(
        onLayout: (_) => _buildPdf(snapshot),
      );
    } catch (e) {
      print('Error printing document: $e');
    }
  }

  FutureOr<Uint8List> _buildPdf(DocumentSnapshot snapshot) async {
    final pdf = pw.Document();
    try {
      final riwayatData = snapshot.data() as Map<String, dynamic>;
      final QuerySnapshot querySnapshot =
          await getBarangRiwayat(snapshot.id).first;
      final List<DocumentSnapshot> docs = querySnapshot.docs;

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Pelanggan: ${riwayatData['pelanggan']}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 16),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Tanggal: ${formatDate(riwayatData['tanggal'])}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 16),
                ),
                pw.Divider(height: 20, thickness: 8, color: PdfColor.fromInt(0xFFf1f5f9)),
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10.0),
                  child: pw.Text(
                    'Daftar Barang',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
                  ),
                ),
                pw.ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final barang = docs[index].data() as Map<String, dynamic>;
                    return pw.Container(
                      margin: const pw.EdgeInsets.symmetric(vertical: 8.0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            barang['nama'],
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
                          ),
                          pw.Text(
                            '${formatCurrency(barang['harga_satuan'])} x ${barang['quantity']}',
                            style: pw.TextStyle(fontSize: 16),
                          ),
                          pw.Text(
                            formatCurrency(barang['total_harga_barang']),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 16.0),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
                      ),
                      pw.Text(
                        formatCurrency(riwayatData['total_harga']),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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
