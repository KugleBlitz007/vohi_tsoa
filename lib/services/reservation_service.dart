import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'reservations';

  // Get reservations for a date
  Stream<List<Reservation>> getReservationsByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _firestore
        .collection(_collection)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reservation.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get all reservations, ordered by date
  Stream<List<Reservation>> getAllReservations() {
    return _firestore
        .collection(_collection)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reservation.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Add a reservation
  Future<void> addReservation(Reservation reservation) async {
    await _firestore.collection(_collection).add(reservation.toMap());
  }

  // Delete a reservation
  Future<void> deleteReservation(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Update a reservation
  Future<void> updateReservation(Reservation reservation) async {
    await _firestore.collection(_collection).doc(reservation.id).update(reservation.toMap());
  }
} 