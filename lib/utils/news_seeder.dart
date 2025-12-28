import 'package:cloud_firestore/cloud_firestore.dart';

class NewsSeeder {
  static Future<void> seedNews() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference newsCollection = firestore.collection('news');

    final List<Map<String, dynamic>> dummyNews = [
      {
        'title': 'Penyuluhan KB di Kecamatan Padang Panjang Barat',
        'content': 'Dinas Kesehatan Kota Padang Panjang mengadakan penyuluhan mengenai pentingnya Keluarga Berencana bagi pasangan usia subur. Acara ini dihadiri oleh warga setempat dengan antusias.',
        'image_url': 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=2070', // Medical/Health related
        'created_at': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'title': 'Pentingnya Gizi Seimbang untuk Ibu Hamil',
        'content': 'Ahli gizi menekankan pentingnya asupan nutrisi yang seimbang selama masa kehamilan untuk mencegah stunting pada anak. Konsumsi sayur dan buah sangat disarankan.',
        'image_url': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=2070', // Healthy food
        'created_at': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'title': 'Jadwal Imunisasi Balita Bulan Ini',
        'content': 'Jangan lewatkan jadwal imunisasi rutin untuk balita Anda di Posyandu terdekat. Imunisasi lengkap melindungi anak dari berbagai penyakit berbahaya.',
        'image_url': 'https://images.unsplash.com/photo-1632053001712-42b781b0a996?auto=format&fit=crop&q=80&w=2070', // Baby/Health
        'created_at': DateTime.now().subtract(const Duration(days: 3)),
      },
    ];

    try {
      for (var news in dummyNews) {
        await newsCollection.add(news);
      }
      print('News seeded successfully!');
    } catch (e) {
      print('Error seeding news: $e');
    }
  }
}
