import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/worker.dart';
import '../services/worker_service.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final WorkerService _workerService = WorkerService();

  // At the top of your PaymentsScreen class (for dev only)
  DateTime simulatedNow = DateTime(2025, 5, 12); // Set to any date you want

  int? lastWeekNumber;

  int getCurrentWeekNumber() {
    //final now = DateTime.now();
    final now = simulatedNow; // Use simulatedNow instead of DateTime.now()
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final daysPassed = now.difference(firstDayOfYear).inDays;
    return ((daysPassed + firstDayOfYear.weekday) / 7).ceil();
  }

  void _showAddWorkerDialog() {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final weeklyPayController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un maçon'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: weeklyPayController,
                decoration: const InputDecoration(labelText: 'Paye hebdomadaire'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final worker = Worker(
                  id: '',
                  name: nameController.text.trim(),
                  weeklyPay: double.tryParse(weeklyPayController.text) ?? 0,
                  unpaidWeeks: {},
                  advanceAmount: 0,
                  advanceNextWeek: false,
                );
                await _workerService.addWorker(worker);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  double _calculateAmountToPay(Worker w, int weekNumber) {
    double unpaid = 0;
    w.unpaidWeeks.forEach((k, v) {
      if (k < weekNumber) unpaid += v;
    });
    double advance = 0;
    if (!w.advanceNextWeek) {
      advance = w.advanceAmount;
    }
    return w.weeklyPay + unpaid - advance;
  }

  @override
  Widget build(BuildContext context) {
    final weekNumber = getCurrentWeekNumber();
    final year = simulatedNow.year;
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion de maçon'), elevation: 0),
      body: StreamBuilder<List<Worker>>(
        stream: _workerService.getWorkersForCurrentWeek(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: \\${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final workers = snapshot.data ?? [];

          // Auto-uncheck advanceNextWeek if week has changed
          if (lastWeekNumber != null && weekNumber != lastWeekNumber) {
            for (final w in workers) {
              if (w.advanceNextWeek && w.advanceAmount > 0) {
                final updated = Worker(
                  id: w.id,
                  name: w.name,
                  weeklyPay: w.weeklyPay,
                  unpaidWeeks: w.unpaidWeeks,
                  advanceAmount: w.advanceAmount,
                  advanceNextWeek: false,
                );
                _workerService.updateWorker(updated);
              }
            }
          }
          lastWeekNumber = weekNumber;

          final totalToPay = workers.fold<double>(0, (sum, w) => sum + _calculateAmountToPay(w, weekNumber));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Semaine $weekNumber de $year', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                color: Colors.red[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Paiements en attente', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Ar ${totalToPay.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Tous les maçons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...workers.map((w) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                child: ListTile(
                  title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: w.advanceAmount > 0
                      ? Text('Avance: Ar ${w.advanceAmount.toStringAsFixed(2)}' + (w.advanceNextWeek ? ' (semaine prochaine)' : ''))
                      : null,
                  trailing: Text('Ar ${_calculateAmountToPay(w, weekNumber).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => _EditWorkerDialog(worker: w, workerService: _workerService, currentWeek: weekNumber),
                    );
                  },
                ),
              )),
              if (workers.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('Aucun maçon à payer cette semaine.', style: TextStyle(color: Colors.grey)),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: _showAddWorkerDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EditWorkerDialog extends StatefulWidget {
  final Worker worker;
  final WorkerService workerService;
  final int currentWeek;
  const _EditWorkerDialog({required this.worker, required this.workerService, required this.currentWeek});

  @override
  State<_EditWorkerDialog> createState() => _EditWorkerDialogState();
}

class _EditWorkerDialogState extends State<_EditWorkerDialog> {
  late TextEditingController nameController;
  late TextEditingController weeklyPayController;
  late TextEditingController advanceController;
  bool advanceNextWeek = false;
  final _formKey = GlobalKey<FormState>();
  late Map<int, double> unpaidWeeks;
  late Map<int, bool> paidWeeks;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.worker.name);
    weeklyPayController = TextEditingController(text: widget.worker.weeklyPay.toString());
    advanceController = TextEditingController(text: widget.worker.advanceAmount.toString());
    advanceNextWeek = widget.worker.advanceNextWeek;
    unpaidWeeks = Map<int, double>.from(widget.worker.unpaidWeeks);
    paidWeeks = {for (var k in unpaidWeeks.keys) k: false};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier le maçon'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: weeklyPayController,
                decoration: const InputDecoration(labelText: 'Paye hebdomadaire'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: advanceController,
                      decoration: const InputDecoration(labelText: 'Avance'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Checkbox(
                    value: advanceNextWeek,
                    onChanged: (val) {
                      setState(() => advanceNextWeek = val ?? false);
                    },
                  ),
                  const Text('Reporter à la prochaine'),
                ],
              ),
              const SizedBox(height: 8),
              if (unpaidWeeks.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Semaines non payées:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...unpaidWeeks.entries.map((e) => Row(
                      children: [
                        Expanded(child: Text('Semaine ${e.key}: Ar ${e.value.toStringAsFixed(2)}')),
                        Checkbox(
                          value: paidWeeks[e.key] ?? false,
                          onChanged: (val) {
                            setState(() {
                              paidWeeks[e.key] = val ?? false;
                            });
                          },
                        ),
                        const Text('Payé'),
                      ],
                    )),
                  ],
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(elevation: 0),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Remove paid weeks
              final updatedUnpaidWeeks = Map<int, double>.from(unpaidWeeks)
                ..removeWhere((k, v) => paidWeeks[k] == true);
              final updated = Worker(
                id: widget.worker.id,
                name: nameController.text.trim(),
                weeklyPay: double.tryParse(weeklyPayController.text) ?? 0,
                unpaidWeeks: updatedUnpaidWeeks,
                advanceAmount: double.tryParse(advanceController.text) ?? 0,
                advanceNextWeek: advanceNextWeek,
              );
              await widget.workerService.updateWorker(updated);
              if (mounted) Navigator.pop(context);
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
} 