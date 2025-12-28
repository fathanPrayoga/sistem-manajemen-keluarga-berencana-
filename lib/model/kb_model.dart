class KbModel {
  String? id;
  String nama;
  String nik;
  String hp;
  String alamat;
  String layanan;
  DateTime tanggal;
  String status;

  KbModel({
    this.id,
    required this.nama,
    required this.nik,
    required this.hp,
    required this.alamat,
    required this.layanan,
    required this.tanggal,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'nik': nik,
    'hp': hp,
    'alamat': alamat,
    'layanan': layanan,
    'tanggal': tanggal.toIso8601String(),
    'status': status,
    'created_at': DateTime.now().toIso8601String(),
  };

  factory KbModel.fromMap(Map<String, dynamic> map, String id) {
    return KbModel(
      id: id,
      nama: map['nama'] ?? '',
      nik: map['nik'] ?? '',
      hp: map['hp'] ?? '',
      alamat: map['alamat'] ?? '',
      layanan: map['layanan'] ?? '',
      tanggal: DateTime.parse(map['tanggal']),
      status: map['status'] ?? 'pending',
    );
  }
}
