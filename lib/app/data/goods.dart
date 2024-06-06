class barang {
  String id;
  final String harga;
  final int nama;
  final String stock;
  final String time;


  barang({
    this.id = "",
    required this.harga,
    required this.nama,
    required this.stock,
    required this.time,

  });

  factory barang.fromJson(Map<String, dynamic> json) {
    return barang(
      id: json['id'] as String,
      harga: json['harga'] as String,
      stock: json['stock'] as String,
      nama: json['nama'] as int,
      time: json['time'] as String,

    );
  }
}
