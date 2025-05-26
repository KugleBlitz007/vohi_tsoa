import 'package:cloud_firestore/cloud_firestore.dart';

class Worker {
  final String id;
  final String name;
  final String firstName;
  final String appellation;
  final DateTime birthDate;
  final String cinNumber;
  final DateTime cinIssueDate;
  final String cinIssuePlace;
  final String cinScanUrl;
  final bool isSingle;
  final bool isMarried;
  final int numberOfChildren;
  final String address;
  final String phone;
  final String email;
  final String photoIdUrl;
  final String responsibilities;
  final DateTime hireDate;
  final List<String> diplomas;
  final String educationLevel;
  final List<String> professionalTraining;
  final List<String> professionalExperience;
  final String emergencyContactName;
  final String emergencyContactRelation;
  final String emergencyContactPhone;
  final String emergencyContactEmail;
  final bool hasSpecialAdvance;
  final double specialAdvanceAmount;
  final DateTime specialAdvanceDate;
  final DateTime specialAdvanceFirstRepaymentDate;
  final double specialAdvanceWeeklyAmount;
  final double specialAdvanceMonthlyAmount;
  final bool hasPunctualAdvance;
  final double punctualAdvanceAmount;
  final DateTime punctualAdvanceDate;
  final DateTime punctualAdvanceRepaymentDate;
  final List<Absence> absences;
  final PaymentType paymentType;
  final double dailyRate;
  final double weeklyRate;
  final double monthlyRate;
  final Map<int, double> unpaidWeeks;
  final double advanceAmount;
  final bool advanceNextWeek;

  Worker({
    required this.id,
    required this.name,
    required this.firstName,
    required this.appellation,
    required this.birthDate,
    required this.cinNumber,
    required this.cinIssueDate,
    required this.cinIssuePlace,
    required this.cinScanUrl,
    required this.isSingle,
    required this.isMarried,
    required this.numberOfChildren,
    required this.address,
    required this.phone,
    required this.email,
    required this.photoIdUrl,
    required this.responsibilities,
    required this.hireDate,
    required this.diplomas,
    required this.educationLevel,
    required this.professionalTraining,
    required this.professionalExperience,
    required this.emergencyContactName,
    required this.emergencyContactRelation,
    required this.emergencyContactPhone,
    required this.emergencyContactEmail,
    required this.hasSpecialAdvance,
    required this.specialAdvanceAmount,
    required this.specialAdvanceDate,
    required this.specialAdvanceFirstRepaymentDate,
    required this.specialAdvanceWeeklyAmount,
    required this.specialAdvanceMonthlyAmount,
    required this.hasPunctualAdvance,
    required this.punctualAdvanceAmount,
    required this.punctualAdvanceDate,
    required this.punctualAdvanceRepaymentDate,
    required this.absences,
    required this.paymentType,
    required this.dailyRate,
    required this.weeklyRate,
    required this.monthlyRate,
    required this.unpaidWeeks,
    required this.advanceAmount,
    required this.advanceNextWeek,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'firstName': firstName,
      'appellation': appellation,
      'birthDate': Timestamp.fromDate(birthDate),
      'cinNumber': cinNumber,
      'cinIssueDate': Timestamp.fromDate(cinIssueDate),
      'cinIssuePlace': cinIssuePlace,
      'cinScanUrl': cinScanUrl,
      'isSingle': isSingle,
      'isMarried': isMarried,
      'numberOfChildren': numberOfChildren,
      'address': address,
      'phone': phone,
      'email': email,
      'photoIdUrl': photoIdUrl,
      'responsibilities': responsibilities,
      'hireDate': Timestamp.fromDate(hireDate),
      'diplomas': diplomas,
      'educationLevel': educationLevel,
      'professionalTraining': professionalTraining,
      'professionalExperience': professionalExperience,
      'emergencyContactName': emergencyContactName,
      'emergencyContactRelation': emergencyContactRelation,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyContactEmail': emergencyContactEmail,
      'hasSpecialAdvance': hasSpecialAdvance,
      'specialAdvanceAmount': specialAdvanceAmount,
      'specialAdvanceDate': Timestamp.fromDate(specialAdvanceDate),
      'specialAdvanceFirstRepaymentDate': Timestamp.fromDate(specialAdvanceFirstRepaymentDate),
      'specialAdvanceWeeklyAmount': specialAdvanceWeeklyAmount,
      'specialAdvanceMonthlyAmount': specialAdvanceMonthlyAmount,
      'hasPunctualAdvance': hasPunctualAdvance,
      'punctualAdvanceAmount': punctualAdvanceAmount,
      'punctualAdvanceDate': Timestamp.fromDate(punctualAdvanceDate),
      'punctualAdvanceRepaymentDate': Timestamp.fromDate(punctualAdvanceRepaymentDate),
      'absences': absences.map((a) => a.toMap()).toList(),
      'paymentType': paymentType.toString(),
      'dailyRate': dailyRate,
      'weeklyRate': weeklyRate,
      'monthlyRate': monthlyRate,
      'unpaidWeeks': unpaidWeeks,
      'advanceAmount': advanceAmount,
      'advanceNextWeek': advanceNextWeek,
    };
  }

  factory Worker.fromMap(String id, Map<String, dynamic> map) {
    return Worker(
      id: id,
      name: map['name'] ?? '',
      firstName: map['firstName'] ?? '',
      appellation: map['appellation'] ?? '',
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      cinNumber: map['cinNumber'] ?? '',
      cinIssueDate: (map['cinIssueDate'] as Timestamp).toDate(),
      cinIssuePlace: map['cinIssuePlace'] ?? '',
      cinScanUrl: map['cinScanUrl'] ?? '',
      isSingle: map['isSingle'] ?? false,
      isMarried: map['isMarried'] ?? false,
      numberOfChildren: map['numberOfChildren'] ?? 0,
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      photoIdUrl: map['photoIdUrl'] ?? '',
      responsibilities: map['responsibilities'] ?? '',
      hireDate: (map['hireDate'] as Timestamp).toDate(),
      diplomas: List<String>.from(map['diplomas'] ?? []),
      educationLevel: map['educationLevel'] ?? '',
      professionalTraining: List<String>.from(map['professionalTraining'] ?? []),
      professionalExperience: List<String>.from(map['professionalExperience'] ?? []),
      emergencyContactName: map['emergencyContactName'] ?? '',
      emergencyContactRelation: map['emergencyContactRelation'] ?? '',
      emergencyContactPhone: map['emergencyContactPhone'] ?? '',
      emergencyContactEmail: map['emergencyContactEmail'] ?? '',
      hasSpecialAdvance: map['hasSpecialAdvance'] ?? false,
      specialAdvanceAmount: map['specialAdvanceAmount']?.toDouble() ?? 0.0,
      specialAdvanceDate: (map['specialAdvanceDate'] as Timestamp).toDate(),
      specialAdvanceFirstRepaymentDate: (map['specialAdvanceFirstRepaymentDate'] as Timestamp).toDate(),
      specialAdvanceWeeklyAmount: map['specialAdvanceWeeklyAmount']?.toDouble() ?? 0.0,
      specialAdvanceMonthlyAmount: map['specialAdvanceMonthlyAmount']?.toDouble() ?? 0.0,
      hasPunctualAdvance: map['hasPunctualAdvance'] ?? false,
      punctualAdvanceAmount: map['punctualAdvanceAmount']?.toDouble() ?? 0.0,
      punctualAdvanceDate: (map['punctualAdvanceDate'] as Timestamp).toDate(),
      punctualAdvanceRepaymentDate: (map['punctualAdvanceRepaymentDate'] as Timestamp).toDate(),
      absences: (map['absences'] as List<dynamic>?)
          ?.map((a) => Absence.fromMap(a as Map<String, dynamic>))
          .toList() ?? [],
      paymentType: PaymentType.values.firstWhere(
        (e) => e.toString() == map['paymentType'],
        orElse: () => PaymentType.weekly,
      ),
      dailyRate: map['dailyRate']?.toDouble() ?? 0.0,
      weeklyRate: map['weeklyRate']?.toDouble() ?? 0.0,
      monthlyRate: map['monthlyRate']?.toDouble() ?? 0.0,
      unpaidWeeks: Map<int, double>.from(map['unpaidWeeks'] ?? {}),
      advanceAmount: map['advanceAmount']?.toDouble() ?? 0.0,
      advanceNextWeek: map['advanceNextWeek'] ?? false,
    );
  }
}

class Absence {
  final DateTime date;
  final int durationDays;
  final double remuneration;

  Absence({
    required this.date,
    required this.durationDays,
    required this.remuneration,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'durationDays': durationDays,
      'remuneration': remuneration,
    };
  }

  factory Absence.fromMap(Map<String, dynamic> map) {
    return Absence(
      date: (map['date'] as Timestamp).toDate(),
      durationDays: map['durationDays'] ?? 0,
      remuneration: map['remuneration']?.toDouble() ?? 0.0,
    );
  }
}

enum PaymentType {
  daily,
  weekly,
  monthly,
} 