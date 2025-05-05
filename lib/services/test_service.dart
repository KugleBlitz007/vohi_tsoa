import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/test_item.dart';

class TestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'test_items';

  // Get all test items
  Stream<List<TestItem>> getTestItems() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TestItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Add a new test item (admin only)
  Future<void> addTestItem(TestItem item) async {
    await _firestore.collection(_collection).add(item.toMap());
  }

  // Update a test item (admin only)
  Future<void> updateTestItem(TestItem item) async {
    await _firestore.collection(_collection).doc(item.id).update(item.toMap());
  }

  // Delete a test item (admin only)
  Future<void> deleteTestItem(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
} 