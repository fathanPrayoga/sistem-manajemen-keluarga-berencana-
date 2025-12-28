import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/news_model.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of Trending News
  Stream<List<NewsModel>> getTrendingNews() {
    return _firestore
        .collection('news') // Assumed collection name
        .orderBy('created_at', descending: true) // Assumed field
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => NewsModel.fromFirestore(doc)).toList();
    });
  }
}
