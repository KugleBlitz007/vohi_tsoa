class Worker {
  final String id;
  final String name;
  final double weeklyPay;
  final Map<int, double> unpaidWeeks; // weekNumber -> amount
  final double advanceAmount;
  final bool advanceNextWeek;

  Worker({
    required this.id,
    required this.name,
    required this.weeklyPay,
    required this.unpaidWeeks,
    required this.advanceAmount,
    required this.advanceNextWeek,
  });

  factory Worker.fromMap(Map<String, dynamic> map, String id) {
    final unpaidWeeksMap = <int, double>{};
    if (map['unpaidWeeks'] != null) {
      (map['unpaidWeeks'] as Map<String, dynamic>).forEach((k, v) {
        unpaidWeeksMap[int.parse(k)] = (v as num).toDouble();
      });
    }
    return Worker(
      id: id,
      name: map['name'] ?? '',
      weeklyPay: (map['weeklyPay'] ?? 0).toDouble(),
      unpaidWeeks: unpaidWeeksMap,
      advanceAmount: (map['advanceAmount'] ?? 0).toDouble(),
      advanceNextWeek: map['advanceNextWeek'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'weeklyPay': weeklyPay,
      'unpaidWeeks': unpaidWeeks.map((k, v) => MapEntry(k.toString(), v)),
      'advanceAmount': advanceAmount,
      'advanceNextWeek': advanceNextWeek,
    };
  }
} 