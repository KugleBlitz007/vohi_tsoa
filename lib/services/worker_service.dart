import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker.dart';

class WorkerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'workers';

  Stream<List<Worker>> getWorkersForCurrentWeek() {
    // For now, fetch all workers. You can add week filtering logic if needed.
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Worker.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addWorker(Worker worker) async {
    await _firestore.collection(_collection).add(worker.toMap());
  }

  Future<void> updateWorker(Worker worker) async {
    await _firestore.collection(_collection).doc(worker.id).update(worker.toMap());
  }
} 