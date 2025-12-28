import 'package:cloud_firestore/cloud_firestore.dart';

class DataSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seed() async {
    await seedNews();
    await seedPengaduan();
    print("✅ Data Seeding Completed!");
  }

  Future<void> seedNews() async {
    final newsCollection = _firestore.collection('news');
    
    // Check if empty to avoid duplicates (optional, but good practice)
    final snapshot = await newsCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print("News collection not empty, skipping seed.");
      return;
    }

    final List<Map<String, dynamic>> newsData = [
      {
        'title': 'Pekan Gizi Nasional 2025',
        'content': 'Pemkot mengadakan pekan gizi untuk mencegah stunting pada balita di 5 kecamatan.',
        'image_url': 'assets/images/foto_dummy_1.jpg',
        'created_at': Timestamp.now(),
      },
      {
        'title': 'Layanan KB Keliling',
        'content': 'Jadwal layanan KB keliling akan hadir di kelurahan A, B, dan C minggu depan.',
        'image_url': 'assets/images/foto_dummy_2.jpg',
        'created_at': Timestamp.now(),
      },
      {
        'title': 'Sosialisasi Kesehatan Reproduksi',
        'content': 'Edukasi kesehatan reproduksi bagi remaja diadakan di berbagai SMA kota ini.',
        'image_url': 'assets/images/foto_dummy_3.png',
        'created_at': Timestamp.now(),
      }
    ];

    for (var data in newsData) {
      await newsCollection.add(data);
    }
    print("Added 3 News items.");
  }

  Future<void> seedPengaduan() async {
    final pengaduanCollection = _firestore.collection('pengaduan');

    // Check if empty
    final snapshot = await pengaduanCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print("Pengaduan collection not empty, skipping seed.");
      return;
    }

    final List<Map<String, dynamic>> pengaduanData = [
      {
        'kategori': 'Infrastruktur',
        'fullname': 'Budi Santoso',
        'nik': '1234567890123456',
        'phone': '08123456789',
        'address': 'Jl. Merpati No. 10',
        'description': 'Jalan berlubang cukup parah di perempatan lampu merah.',
        'imageUrl': '', // No image
        'status': 'pending',
        'timestamp': Timestamp.now(),
      },
      {
        'kategori': 'Kesehatan',
        'fullname': 'Siti Aminah',
        'nik': '9876543210987654',
        'phone': '08987654321',
        'address': 'Komp. Griya Indah Blok A1',
        'description': 'Pelayanan di Puskesmas X sangat lambat hari ini.',
        'imageUrl': '',
        'status': 'processed',
        'timestamp': Timestamp.now(),
      },
      {
        'kategori': 'Kebersihan',
        'fullname': 'Rudi Hartono',
        'nik': '1122334455667788',
        'phone': '08567890123',
        'address': 'Jl. A. Yani Pasar Bawah',
        'description': 'Sampah menumpuk di area pasar belum diangkut 2 hari.',
        'imageUrl': '',
        'status': 'done',
        'timestamp': Timestamp.now(),
      }
    ];

    for (var data in pengaduanData) {
      await pengaduanCollection.add(data);
    }
    print("Added 3 Pengaduan items.");
  }
}
