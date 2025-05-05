class WorkerWeek {
  final int weekNumber;
  final int year;
  double payAmount;
  bool paid;
  double advance; // advance applied this week
  double advanceNextWeek; // advance to be applied next week

  WorkerWeek({
    required this.weekNumber,
    required this.year,
    required this.payAmount,
    this.paid = false,
    this.advance = 0,
    this.advanceNextWeek = 0,
  });

  factory WorkerWeek.fromMap(Map<String, dynamic> map) {
    return WorkerWeek(
      weekNumber: map['weekNumber'],
      year: map['year'],
      payAmount: (map['payAmount'] ?? 0).toDouble(),
      paid: map['paid'] ?? false,
      advance: (map['advance'] ?? 0).toDouble(),
      advanceNextWeek: (map['advanceNextWeek'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weekNumber': weekNumber,
      'year': year,
      'payAmount': payAmount,
      'paid': paid,
      'advance': advance,
      'advanceNextWeek': advanceNextWeek,
    };
  }
}
