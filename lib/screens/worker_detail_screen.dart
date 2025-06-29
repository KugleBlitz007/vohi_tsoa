import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/worker.dart';
import 'worker_form_screen.dart';

class WorkerDetailScreen extends StatelessWidget {
  final Worker worker;
  const WorkerDetailScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du maçon'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkerFormScreen(worker: worker),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _infoTile('Nom', worker.name),
          _infoTile('Prénom', worker.firstName),
          _infoTile('Appellation', worker.appellation),
          _infoTile('Date de naissance', DateFormat('yyyy-MM-dd').format(worker.birthDate)),
          _infoTile('Numéro CIN', worker.cinNumber),
          _infoTile('Date délivrance CIN', DateFormat('yyyy-MM-dd').format(worker.cinIssueDate)),
          _infoTile('Lieu délivrance CIN', worker.cinIssuePlace),
          _infoTile('Adresse', worker.address),
          _infoTile('Téléphone', worker.phone),
          _infoTile('Email', worker.email),
          _infoTile('Responsabilités', worker.responsibilities),
          _infoTile('Date d\'embauche', DateFormat('yyyy-MM-dd').format(worker.hireDate)),
          _infoTile('Niveau d\'études', worker.educationLevel),
          _infoTile('Situation familiale', worker.isMarried ? 'Marié' : (worker.isSingle ? 'Célibataire' : '')),
          _infoTile('Nombre d\'enfants', worker.numberOfChildren.toString()),
          _infoTile('Contact urgence', '${worker.emergencyContactName} (${worker.emergencyContactRelation}) - ${worker.emergencyContactPhone}'),
          _infoTile('Type de paiement', worker.paymentType.toString().split('.').last),
          _infoTile('Taux journalier', 'Ar ${worker.dailyRate.toStringAsFixed(2)}'),
          _infoTile('Taux hebdomadaire', 'Ar ${worker.weeklyRate.toStringAsFixed(2)}'),
          _infoTile('Taux mensuel', 'Ar ${worker.monthlyRate.toStringAsFixed(2)}'),
          if (worker.absences.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('Absences', style: TextStyle(fontWeight: FontWeight.bold)),
                ...worker.absences.map((a) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '${DateFormat('yyyy-MM-dd').format(a.date)} - ${a.durationDays} jour(s), Rémunération: Ar ${a.remuneration.toStringAsFixed(2)}',
                  ),
                )),
              ],
            ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 160, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
} 