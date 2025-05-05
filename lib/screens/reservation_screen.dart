import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';
import '../services/auth_service.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final ReservationService _reservationService = ReservationService();
  final AuthService _authService = AuthService();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _authService.isUserAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  // Group reservations by date
  Map<String, List<Reservation>> _groupByDate(List<Reservation> reservations) {
    final map = <String, List<Reservation>>{};
    for (final r in reservations) {
      final dateStr = DateFormat('EEE, MMM d, yyyy').format(r.date);
      map.putIfAbsent(dateStr, () => []).add(r);
    }
    return map;
  }

  void _showAddReservationDialog() {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final timeController = TextEditingController();
    final numberOfPeopleController = TextEditingController();
    final courtesyController = TextEditingController();
    final phoneController = TextEditingController();
    final moneyAdvanceController = TextEditingController();
    final restToPayController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    bool courtesy = false;
    int courtesyCount = 0;
    List<String> selectedServices = [];
    final List<String> allServices = [
      'Piscine', 'Terrasse', 'Autres'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter une réservation'),
              content: SingleChildScrollView(
                child: Form(
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
                        controller: numberOfPeopleController,
                        decoration: const InputDecoration(labelText: 'Nombre de personnes'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: courtesy,
                            onChanged: (val) {
                              setState(() => courtesy = val ?? false);
                            },
                          ),
                          const Text('Couverts'),
                          if (courtesy)
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                controller: courtesyController,
                                decoration: const InputDecoration(labelText: 'Combien?'),
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (courtesy && (v == null || v.isEmpty)) return 'Requis';
                                  return null;
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Services', style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      ...allServices.map((service) => CheckboxListTile(
                        value: selectedServices.contains(service),
                        title: Text(service),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedServices.add(service);
                            } else {
                              selectedServices.remove(service);
                            }
                          });
                        },
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                      )),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: moneyAdvanceController,
                        decoration: const InputDecoration(labelText: 'Avance d\'argent'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: restToPayController,
                        decoration: const InputDecoration(labelText: 'Reste à payer'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(selectedDate == null
                                ? 'Sélectionner une date'
                                : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => selectedDate = picked);
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(selectedTime == null
                                ? 'Sélectionner le temps'
                                : selectedTime!.format(context)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() => selectedTime = picked);
                              }
                            },
                          ),
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
                    if (_formKey.currentState!.validate() && selectedDate != null && selectedTime != null) {
                      final dt = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                      final reservation = Reservation(
                        id: '',
                        name: nameController.text.trim(),
                        time: dt,
                        numberOfPeople: int.tryParse(numberOfPeopleController.text) ?? 1,
                        courtesy: courtesy,
                        courtesyCount: courtesy ? int.tryParse(courtesyController.text) ?? 0 : 0,
                        services: selectedServices,
                        phone: phoneController.text.trim(),
                        moneyAdvance: double.tryParse(moneyAdvanceController.text) ?? 0,
                        restToPay: double.tryParse(restToPayController.text) ?? 0,
                        date: DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day),
                      );
                      await _reservationService.addReservation(reservation);
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réservations'), elevation: 0),
      body: StreamBuilder<List<Reservation>>(
        stream: _reservationService.getAllReservations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: \\${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final reservations = snapshot.data ?? [];
          final grouped = _groupByDate(reservations);
          final allDates = grouped.keys.toList()..sort((a, b) => DateFormat('EEE, MMM d, yyyy').parse(a).compareTo(DateFormat('EEE, MMM d, yyyy').parse(b)));

          if (allDates.isEmpty) {
            return const Center(child: Text('Aucune réservation pour le moment'));
          }

          return ListView.builder(
            itemCount: allDates.length,
            itemBuilder: (context, index) {
              final date = allDates[index];
              final events = grouped[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  if (events.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text('Aucun événement', style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ...events.map((event) => _ReservationCard(event: event)).toList(),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              elevation: 0,
              onPressed: _showAddReservationDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation event;
  const _ReservationCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(event.time);
    final servicesStr = event.services.join(', ');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold)),
            event.restToPay == 0
                ? const Text('PAID', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold))
                : Text('Ar ${event.restToPay.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(servicesStr),
        onTap: () async {
          final isAdmin = await AuthService().isUserAdmin();
          showDialog(
            context: context,
            builder: (context) {
              return _ReservationDetailsDialog(event: event, isAdmin: isAdmin);
            },
          );
        },
      ),
    );
  }
}

class _ReservationDetailsDialog extends StatelessWidget {
  final Reservation event;
  final bool isAdmin;
  const _ReservationDetailsDialog({required this.event, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(event.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Time: ${DateFormat('yyyy-MM-dd HH:mm').format(event.time)}'),
            Text('Number of people: ${event.numberOfPeople}'),
            Text('Couverts: ${event.courtesy ? 'Yes (${event.courtesyCount})' : 'No'}'),
            Text('Services: ${event.services.join(', ')}'),
            Text('Phone: ${event.phone}'),
            Text('Money advance: Ar ${event.moneyAdvance.toStringAsFixed(2)}'),
            Text('Rest to pay: Ar ${event.restToPay.toStringAsFixed(2)}'),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(event.date)}'),
          ],
        ),
      ),
      actions: [
        if (isAdmin)
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close details dialog
              await showDialog(
                context: context,
                builder: (context) => _EditReservationDialog(event: event),
              );
            },
            child: const Text('Edit'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _EditReservationDialog extends StatefulWidget {
  final Reservation event;
  const _EditReservationDialog({required this.event});

  @override
  State<_EditReservationDialog> createState() => _EditReservationDialogState();
}

class _EditReservationDialogState extends State<_EditReservationDialog> {
  late TextEditingController nameController;
  late TextEditingController numberOfPeopleController;
  late TextEditingController courtesyController;
  late TextEditingController phoneController;
  late TextEditingController moneyAdvanceController;
  late TextEditingController restToPayController;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool courtesy = false;
  List<String> selectedServices = [];
  final List<String> allServices = [
    'Piscine', 'Terrasse', 'Autres'
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    nameController = TextEditingController(text: e.name);
    numberOfPeopleController = TextEditingController(text: e.numberOfPeople.toString());
    courtesyController = TextEditingController(text: e.courtesyCount.toString());
    phoneController = TextEditingController(text: e.phone);
    moneyAdvanceController = TextEditingController(text: e.moneyAdvance.toString());
    restToPayController = TextEditingController(text: e.restToPay.toString());
    selectedDate = e.date;
    selectedTime = TimeOfDay(hour: e.time.hour, minute: e.time.minute);
    courtesy = e.courtesy;
    selectedServices = List<String>.from(e.services);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier la réservation'),
      content: SingleChildScrollView(
        child: Form(
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
                controller: numberOfPeopleController,
                decoration: const InputDecoration(labelText: 'Nombre de personnes'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: courtesy,
                    onChanged: (val) {
                      setState(() => courtesy = val ?? false);
                    },
                  ),
                  const Text('Couverts'),
                  if (courtesy)
                    SizedBox(
                      width: 60,
                      child: TextFormField(
                        controller: courtesyController,
                        decoration: const InputDecoration(labelText: 'Combien?'),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (courtesy && (v == null || v.isEmpty)) return 'Requis';
                          return null;
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Services', style: Theme.of(context).textTheme.bodyMedium),
              ),
              ...allServices.map((service) => CheckboxListTile(
                value: selectedServices.contains(service),
                title: Text(service),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      selectedServices.add(service);
                    } else {
                      selectedServices.remove(service);
                    }
                  });
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              )),
              const SizedBox(height: 8),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: moneyAdvanceController,
                decoration: const InputDecoration(labelText: 'Avance d\'argent'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: restToPayController,
                decoration: const InputDecoration(labelText: 'Reste à payer'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(selectedTime.format(context)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                  ),
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
              final dt = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              final updated = Reservation(
                id: widget.event.id,
                name: nameController.text.trim(),
                time: dt,
                numberOfPeople: int.tryParse(numberOfPeopleController.text) ?? 1,
                courtesy: courtesy,
                courtesyCount: courtesy ? int.tryParse(courtesyController.text) ?? 0 : 0,
                services: selectedServices,
                phone: phoneController.text.trim(),
                moneyAdvance: double.tryParse(moneyAdvanceController.text) ?? 0,
                restToPay: double.tryParse(restToPayController.text) ?? 0,
                date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
              );
              await ReservationService().updateReservation(updated);
              if (mounted) Navigator.pop(context);
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
} 