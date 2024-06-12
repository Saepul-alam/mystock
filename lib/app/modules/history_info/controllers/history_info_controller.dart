import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

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

  Future<void> printPdf(List<Map<String, dynamic>> barangRiwayatData, String jenis, int tanggal) async {
    final pdf = pw.Document();
    
    // Header
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text("Detail Riwayat $jenis", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text("Tanggal: ${DateFormat('dd MMMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(tanggal))}"),
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Nama Barang', 'Harga Satuan', 'Quantity', 'Total Harga']
          ]),
          for (var barang in barangRiwayatData) pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>[barang['name'] ?? '', barang['harga'] != null ? formatCurrency(int.parse(barang['harga'])) : '', barang['quantity'] != null ? barang['quantity'].toString() : '', barang['total'] != null ? formatCurrency(int.parse(barang['total'])) : '']
          ]),
        ],
      ),
    );

    // Save the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
}

}
