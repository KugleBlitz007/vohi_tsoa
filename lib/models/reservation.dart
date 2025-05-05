import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String name;
  final DateTime time;
  final int numberOfPeople;
  final bool courtesy;
  final int courtesyCount;
  final List<String> services;
  final String phone;
  final double moneyAdvance;
  final double restToPay;
  final DateTime date;

  Reservation({
    required this.id,
    required this.name,
    required this.time,
    required this.numberOfPeople,
    required this.courtesy,
    required this.courtesyCount,
    required this.services,
    required this.phone,
    required this.moneyAdvance,
    required this.restToPay,
    required this.date,
  });

  factory Reservation.fromMap(Map<String, dynamic> map, String id) {
    return Reservation(
      id: id,
      name: map['name'] ?? '',
      time: (map['time'] as Timestamp).toDate(),
      numberOfPeople: map['numberOfPeople'] ?? 0,
      courtesy: map['courtesy'] ?? false,
      courtesyCount: map['courtesyCount'] ?? 0,
      services: List<String>.from(map['services'] ?? []),
      phone: map['phone'] ?? '',
      moneyAdvance: (map['moneyAdvance'] ?? 0).toDouble(),
      restToPay: (map['restToPay'] ?? 0).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'numberOfPeople': numberOfPeople,
      'courtesy': courtesy,
      'courtesyCount': courtesyCount,
      'services': services,
      'phone': phone,
      'moneyAdvance': moneyAdvance,
      'restToPay': restToPay,
      'date': date,
    };
  }
} 