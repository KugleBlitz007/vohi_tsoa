import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/worker.dart';
import '../services/worker_service.dart';
import 'worker_form_screen.dart';
import 'worker_detail_screen.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final WorkerService _workerService = WorkerService();
  DateTime _selectedMonth = DateTime.now();
  int _selectedYear = DateTime.now().year;
  int _selectedWeek = 1;
  bool _isWeekView = false;

  int getCurrentWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysPassed = date.difference(firstDayOfYear).inDays;
    return ((daysPassed + firstDayOfYear.weekday) / 7).ceil();
  }

  @override
  void initState() {
    super.initState();
    _selectedWeek = getCurrentWeekNumber(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de maçon'),
        elevation: 0,
        actions: [
          ToggleButtons(
            isSelected: [_isWeekView, !_isWeekView],
            onPressed: (index) {
              setState(() {
                _isWeekView = index == 0;
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Par semaine'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Par mois'),
              ),
            ],
          ),
          const SizedBox(width: 8),
          if (_isWeekView)
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final result = await showDialog<Map<String, int>>(
                  context: context,
                  builder: (context) {
                    int tempYear = _selectedYear;
                    int tempWeek = _selectedWeek;
                    return AlertDialog(
                      title: const Text('Choisir la période (semaine)'),
                      content: SizedBox(
                        height: 180,
                        width: 300,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<int>(
                              value: tempYear,
                              isExpanded: true,
                              items: List.generate(11, (i) => DateTime.now().year - 5 + i)
                                  .map((y) => DropdownMenuItem(
                                        value: y,
                                        child: Text(y.toString()),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  tempYear = v;
                                  (context as Element).markNeedsBuild();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButton<int>(
                              value: tempWeek,
                              isExpanded: true,
                              items: List.generate(53, (i) => i + 1)
                                  .map((w) => DropdownMenuItem(
                                        value: w,
                                        child: Text('Semaine $w'),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  tempWeek = v;
                                  (context as Element).markNeedsBuild();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(elevation: 0),
                          onPressed: () {
                            Navigator.pop(context, {'year': tempYear, 'week': tempWeek});
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                if (result != null) {
                  setState(() {
                    _selectedYear = result['year']!;
                    _selectedWeek = result['week']!;
                  });
                }
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final result = await showDialog<Map<String, int>>(
                  context: context,
                  builder: (context) {
                    int tempYear = _selectedMonth.year;
                    int tempMonth = _selectedMonth.month;
                    return AlertDialog(
                      title: const Text('Choisir la période (mois)'),
                      content: SizedBox(
                        height: 180,
                        width: 300,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<int>(
                              value: tempYear,
                              isExpanded: true,
                              items: List.generate(11, (i) => DateTime.now().year - 5 + i)
                                  .map((y) => DropdownMenuItem(
                                        value: y,
                                        child: Text(y.toString()),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  tempYear = v;
                                  (context as Element).markNeedsBuild();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButton<int>(
                              value: tempMonth,
                              isExpanded: true,
                              items: List.generate(12, (i) => i + 1)
                                  .map((m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(DateFormat('MMMM', 'fr_FR').format(DateTime(0, m))),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  tempMonth = v;
                                  (context as Element).markNeedsBuild();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(elevation: 0),
                          onPressed: () {
                            Navigator.pop(context, {'year': tempYear, 'month': tempMonth});
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                if (result != null) {
                  setState(() {
                    _selectedMonth = DateTime(result['year']!, result['month']!, 1);
                  });
                }
              },
            ),
        ],
      ),
      body: StreamBuilder<List<Worker>>(
        stream: _workerService.getWorkersForCurrentWeek(),
        builder: (context, AsyncSnapshot<List<Worker>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Une erreur est survenue: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final workers = snapshot.data ?? [];

          if (workers.isEmpty) {
            return const Center(
              child: Text(
                'Pas de travailleur dans la base de données',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          String periodLabel;
          if (_isWeekView) {
            periodLabel = 'Semaine $_selectedWeek de $_selectedYear';
          } else {
            periodLabel = DateFormat('MMMM yyyy', 'fr_FR').format(_selectedMonth);
          }

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    periodLabel,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Appellation')),
                          DataColumn(label: Text('Montant à payer (en Ariary)')),
                        ],
                        rows: workers.map((worker) {
                          double montant = 0;
                          if (_isWeekView) {
                            // Calculate for week
                            DateTime firstDayOfYear = DateTime(_selectedYear, 1, 1);
                            int daysOffset = (_selectedWeek - 1) * 7 - (firstDayOfYear.weekday - 1);
                            DateTime weekStart = firstDayOfYear.add(Duration(days: daysOffset));
                            DateTime weekEnd = weekStart.add(const Duration(days: 6));
                            if (worker.paymentType == PaymentType.daily) {
                              // Count non-absent days in the week (regardless of month)
                              int paidDays = 0;
                              for (int i = 0; i < 7; i++) {
                                DateTime day = weekStart.add(Duration(days: i));
                                bool isAbsent = worker.absences.any((a) {
                                  DateTime absenceStart = a.date;
                                  DateTime absenceEnd = absenceStart.add(Duration(days: a.durationDays - 1));
                                  return !day.isBefore(absenceStart) && !day.isAfter(absenceEnd);
                                });
                                if (!isAbsent) {
                                  paidDays++;
                                }
                              }
                              montant = paidDays * worker.dailyRate;
                            } else if (worker.paymentType == PaymentType.weekly) {
                              montant = worker.weeklyRate;
                            } else {
                              montant = worker.monthlyRate / 4.345;
                            }
                          } else {
                            // Calculate for month
                            int daysInMonth = DateUtils.getDaysInMonth(_selectedMonth.year, _selectedMonth.month);
                            if (worker.paymentType == PaymentType.daily) {
                              int paidDays = 0;
                              for (int i = 1; i <= daysInMonth; i++) {
                                DateTime day = DateTime(_selectedMonth.year, _selectedMonth.month, i);
                                bool isAbsent = worker.absences.any((a) {
                                  DateTime absenceStart = a.date;
                                  DateTime absenceEnd = absenceStart.add(Duration(days: a.durationDays - 1));
                                  return !day.isBefore(absenceStart) && !day.isAfter(absenceEnd);
                                });
                                if (!isAbsent) {
                                  paidDays++;
                                }
                              }
                              montant = paidDays * worker.dailyRate;
                            } else if (worker.paymentType == PaymentType.weekly) {
                              montant = worker.weeklyRate * (daysInMonth / 7);
                            } else {
                              montant = worker.monthlyRate;
                            }
                          }
                          montant -= worker.advanceAmount;
                          return DataRow(
                            cells: [
                              DataCell(
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkerDetailScreen(worker: worker),
                                      ),
                                    );
                                  },
                                  child: Text(worker.appellation),
                                ),
                              ),
                              DataCell(Text(NumberFormat('#,###', 'fr_FR').format(montant))),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WorkerFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 