import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HistoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

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
    }

    return query.snapshots();
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

  Future<void> printPdf(List<QueryDocumentSnapshot<Object?>> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Center(
            child: pw.Text(
              'Invoice',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var document = data[index];
              return pw.Container(
                padding: pw.EdgeInsets.all(15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Pelanggan: ${document['pelanggan']}"),
                    pw.Text(
                        "Total Harga: ${formatCurrency(document['total_harga'])}"),
                    pw.Text("Tanggal: ${formatDate(document['tanggal'])}"),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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
