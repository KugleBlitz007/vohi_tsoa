import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker.dart';

class WorkerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'workers';

  Stream<List<Worker>> getWorkersForCurrentWeek() {
    try {
      return _firestore
          .collection(_collection)
          .snapshots()
          .map((snapshot) {
            try {
              return snapshot.docs.map((doc) {
                try {
                  return Worker.fromMap(doc.id, doc.data());
                } catch (e) {
                  print('Error converting document ${doc.id}: $e');
                  return null;
                }
              }).where((worker) => worker != null).cast<Worker>().toList();
            } catch (e) {
              print('Error processing snapshot: $e');
              return <Worker>[];
            }
          });
    } catch (e) {
      print('Error setting up stream: $e');
      return Stream.value(<Worker>[]);
    }
  }

  Future<void> addWorker(Worker worker) async {
    try {
      await _firestore.collection(_collection).add(worker.toMap());
    } catch (e) {
      print('Error adding worker: $e');
      rethrow;
    }
  }

  Future<void> updateWorker(Worker worker) async {
    try {
      await _firestore.collection(_collection).doc(worker.id).update(worker.toMap());
    } catch (e) {
      print('Error updating worker: $e');
      rethrow;
    }
  }
} 