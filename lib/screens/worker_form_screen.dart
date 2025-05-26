import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/worker.dart';
import '../services/worker_service.dart';

class WorkerFormScreen extends StatefulWidget {
  final Worker? worker;
  const WorkerFormScreen({super.key, this.worker});

  @override
  State<WorkerFormScreen> createState() => _WorkerFormScreenState();
}

class _WorkerFormScreenState extends State<WorkerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workerService = WorkerService();
  
  // Personal Information
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _appellationController = TextEditingController();
  DateTime? _birthDate;
  final _cinNumberController = TextEditingController();
  DateTime? _cinIssueDate;
  final _cinIssuePlaceController = TextEditingController();
  String? _cinScanUrl;
  
  // Family Situation
  bool _isSingle = false;
  bool _isMarried = false;
  final _numberOfChildrenController = TextEditingController();
  
  // Contact Information
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _photoIdUrl;
  
  // Employment Information
  final _responsibilitiesController = TextEditingController();
  DateTime? _hireDate;
  final List<String> _diplomas = [];
  final _educationLevelController = TextEditingController();
  final List<String> _professionalTraining = [];
  final List<String> _professionalExperience = [];
  
  // Emergency Contact
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactRelationController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _emergencyContactEmailController = TextEditingController();
  
  // Advances
  bool _hasSpecialAdvance = false;
  final _specialAdvanceAmountController = TextEditingController();
  DateTime? _specialAdvanceDate;
  DateTime? _specialAdvanceFirstRepaymentDate;
  final _specialAdvanceWeeklyAmountController = TextEditingController();
  final _specialAdvanceMonthlyAmountController = TextEditingController();
  
  bool _hasPunctualAdvance = false;
  final _punctualAdvanceAmountController = TextEditingController();
  DateTime? _punctualAdvanceDate;
  DateTime? _punctualAdvanceRepaymentDate;
  
  // Absences
  final List<Absence> _absences = [];
  
  // Payment Information
  PaymentType _paymentType = PaymentType.weekly;
  final _dailyRateController = TextEditingController();
  final _weeklyRateController = TextEditingController();
  final _monthlyRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.worker != null) {
      _loadWorkerData();
    }
  }

  void _loadWorkerData() {
    final worker = widget.worker!;
    _nameController.text = worker.name;
    _firstNameController.text = worker.firstName;
    _appellationController.text = worker.appellation;
    _birthDate = worker.birthDate;
    _cinNumberController.text = worker.cinNumber;
    _cinIssueDate = worker.cinIssueDate;
    _cinIssuePlaceController.text = worker.cinIssuePlace;
    _cinScanUrl = worker.cinScanUrl;
    _isSingle = worker.isSingle;
    _isMarried = worker.isMarried;
    _numberOfChildrenController.text = worker.numberOfChildren.toString();
    _addressController.text = worker.address;
    _phoneController.text = worker.phone;
    _emailController.text = worker.email;
    _photoIdUrl = worker.photoIdUrl;
    _responsibilitiesController.text = worker.responsibilities;
    _hireDate = worker.hireDate;
    _diplomas.addAll(worker.diplomas);
    _educationLevelController.text = worker.educationLevel;
    _professionalTraining.addAll(worker.professionalTraining);
    _professionalExperience.addAll(worker.professionalExperience);
    _emergencyContactNameController.text = worker.emergencyContactName;
    _emergencyContactRelationController.text = worker.emergencyContactRelation;
    _emergencyContactPhoneController.text = worker.emergencyContactPhone;
    _emergencyContactEmailController.text = worker.emergencyContactEmail;
    _hasSpecialAdvance = worker.hasSpecialAdvance;
    _specialAdvanceAmountController.text = worker.specialAdvanceAmount.toString();
    _specialAdvanceDate = worker.specialAdvanceDate;
    _specialAdvanceFirstRepaymentDate = worker.specialAdvanceFirstRepaymentDate;
    _specialAdvanceWeeklyAmountController.text = worker.specialAdvanceWeeklyAmount.toString();
    _specialAdvanceMonthlyAmountController.text = worker.specialAdvanceMonthlyAmount.toString();
    _hasPunctualAdvance = worker.hasPunctualAdvance;
    _punctualAdvanceAmountController.text = worker.punctualAdvanceAmount.toString();
    _punctualAdvanceDate = worker.punctualAdvanceDate;
    _punctualAdvanceRepaymentDate = worker.punctualAdvanceRepaymentDate;
    _absences.addAll(worker.absences);
    _paymentType = worker.paymentType;
    _dailyRateController.text = worker.dailyRate.toString();
    _weeklyRateController.text = worker.weeklyRate.toString();
    _monthlyRateController.text = worker.monthlyRate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.worker == null ? 'Ajouter un maçon' : 'Modifier le maçon'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Informations personnelles'),
            _buildPersonalInfoSection(),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Situation familiale'),
            _buildFamilySituationSection(),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Informations de contact'),
            _buildContactInfoSection(),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Informations professionnelles'),
            _buildProfessionalInfoSection(),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Personne à contacter en cas d\'urgence'),
            _buildEmergencyContactSection(),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Avances'),
            _buildAdvancesSection(),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Absences'),
            _buildAbsencesSection(),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Rémunération'),
            _buildPaymentSection(),
            const SizedBox(height: 32),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: _saveWorker,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nom'),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: 'Prénom'),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        TextFormField(
          controller: _appellationController,
          decoration: const InputDecoration(labelText: 'Appellation'),
        ),
        ListTile(
          title: Text(_birthDate == null
              ? 'Date de naissance'
              : DateFormat('yyyy-MM-dd').format(_birthDate!)),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _birthDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _birthDate = date);
            }
          },
        ),
        TextFormField(
          controller: _cinNumberController,
          decoration: const InputDecoration(labelText: 'Numéro CIN'),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        ListTile(
          title: Text(_cinIssueDate == null
              ? 'Date de délivrance CIN'
              : DateFormat('yyyy-MM-dd').format(_cinIssueDate!)),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _cinIssueDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _cinIssueDate = date);
            }
          },
        ),
        TextFormField(
          controller: _cinIssuePlaceController,
          decoration: const InputDecoration(labelText: 'Lieu de délivrance CIN'),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        // TODO: Add CIN scan upload functionality
      ],
    );
  }

  Widget _buildFamilySituationSection() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Célibataire'),
          value: _isSingle,
          onChanged: (v) {
            setState(() {
              _isSingle = v ?? false;
              if (_isSingle) _isMarried = false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Marié'),
          value: _isMarried,
          onChanged: (v) {
            setState(() {
              _isMarried = v ?? false;
              if (_isMarried) _isSingle = false;
            });
          },
        ),
        TextFormField(
          controller: _numberOfChildrenController,
          decoration: const InputDecoration(labelText: 'Nombre d\'enfants'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      children: [
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Adresse'),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Téléphone'),
          keyboardType: TextInputType.phone,
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        // TODO: Add photo ID upload functionality
      ],
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Column(
      children: [
        TextFormField(
          controller: _responsibilitiesController,
          decoration: const InputDecoration(labelText: 'Responsabilités'),
          maxLines: 3,
        ),
        ListTile(
          title: Text(_hireDate == null
              ? 'Date d\'embauche'
              : DateFormat('yyyy-MM-dd').format(_hireDate!)),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _hireDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _hireDate = date);
            }
          },
        ),
        // TODO: Add diplomas management
        TextFormField(
          controller: _educationLevelController,
          decoration: const InputDecoration(labelText: 'Niveau d\'études'),
        ),
        // TODO: Add professional training management
        // TODO: Add professional experience management
      ],
    );
  }

  Widget _buildEmergencyContactSection() {
    return Column(
      children: [
        TextFormField(
          controller: _emergencyContactNameController,
          decoration: const InputDecoration(labelText: 'Nom et prénom'),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        TextFormField(
          controller: _emergencyContactRelationController,
          decoration: const InputDecoration(labelText: 'Lien avec l\'employé'),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        TextFormField(
          controller: _emergencyContactPhoneController,
          decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
          keyboardType: TextInputType.phone,
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        TextFormField(
          controller: _emergencyContactEmailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildAdvancesSection() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Avance spéciale'),
          value: _hasSpecialAdvance,
          onChanged: (v) {
            setState(() {
              _hasSpecialAdvance = v ?? false;
              if (!_hasSpecialAdvance) _hasPunctualAdvance = false;
            });
          },
        ),
        if (_hasSpecialAdvance) ...[
          TextFormField(
            controller: _specialAdvanceAmountController,
            decoration: const InputDecoration(labelText: 'Montant'),
            keyboardType: TextInputType.number,
          ),
          ListTile(
            title: Text(_specialAdvanceDate == null
                ? 'Date de réception'
                : DateFormat('yyyy-MM-dd').format(_specialAdvanceDate!)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _specialAdvanceDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() => _specialAdvanceDate = date);
              }
            },
          ),
          ListTile(
            title: Text(_specialAdvanceFirstRepaymentDate == null
                ? 'Date du premier remboursement'
                : DateFormat('yyyy-MM-dd').format(_specialAdvanceFirstRepaymentDate!)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _specialAdvanceFirstRepaymentDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() => _specialAdvanceFirstRepaymentDate = date);
              }
            },
          ),
          TextFormField(
            controller: _specialAdvanceWeeklyAmountController,
            decoration: const InputDecoration(labelText: 'Montant à rembourser par semaine'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _specialAdvanceMonthlyAmountController,
            decoration: const InputDecoration(labelText: 'Montant à rembourser par mois'),
            keyboardType: TextInputType.number,
          ),
        ],
        CheckboxListTile(
          title: const Text('Avance ponctuelle'),
          value: _hasPunctualAdvance,
          onChanged: (v) {
            setState(() {
              _hasPunctualAdvance = v ?? false;
              if (!_hasPunctualAdvance) _hasSpecialAdvance = false;
            });
          },
        ),
        if (_hasPunctualAdvance) ...[
          TextFormField(
            controller: _punctualAdvanceAmountController,
            decoration: const InputDecoration(labelText: 'Montant'),
            keyboardType: TextInputType.number,
          ),
          ListTile(
            title: Text(_punctualAdvanceDate == null
                ? 'Date de réception'
                : DateFormat('yyyy-MM-dd').format(_punctualAdvanceDate!)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _punctualAdvanceDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() => _punctualAdvanceDate = date);
              }
            },
          ),
          ListTile(
            title: Text(_punctualAdvanceRepaymentDate == null
                ? 'Date de remboursement'
                : DateFormat('yyyy-MM-dd').format(_punctualAdvanceRepaymentDate!)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _punctualAdvanceRepaymentDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() => _punctualAdvanceRepaymentDate = date);
              }
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAbsencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._absences.asMap().entries.map((entry) {
          final i = entry.key;
          final absence = entry.value;
          return ListTile(
            title: Text('Date: ' + DateFormat('yyyy-MM-dd').format(absence.date)),
            subtitle: Text('Durée: ${absence.durationDays} jour(s), Rémunération: Ar ${absence.remuneration.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _absences.removeAt(i);
                });
              },
            ),
          );
        }),
        ElevatedButton(
          style: ElevatedButton.styleFrom(elevation: 0),
          onPressed: () async {
            final result = await showDialog<Absence>(
              context: context,
              builder: (context) => _AddAbsenceDialog(),
            );
            if (result != null) {
              setState(() {
                _absences.add(result);
              });
            }
          },
          child: const Text('Ajouter une absence'),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      children: [
        DropdownButtonFormField<PaymentType>(
          value: _paymentType,
          decoration: const InputDecoration(labelText: 'Type de paiement'),
          items: PaymentType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.toString().split('.').last),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) {
              setState(() => _paymentType = v);
            }
          },
        ),
        TextFormField(
          controller: _dailyRateController,
          decoration: const InputDecoration(labelText: 'Taux journalier'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: _weeklyRateController,
          decoration: const InputDecoration(labelText: 'Taux hebdomadaire'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: _monthlyRateController,
          decoration: const InputDecoration(labelText: 'Taux mensuel'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Future<void> _saveWorker() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final worker = Worker(
          id: widget.worker?.id ?? '',
          name: _nameController.text.trim(),
          firstName: _firstNameController.text.trim(),
          appellation: _appellationController.text.trim(),
          birthDate: _birthDate ?? DateTime.now(),
          cinNumber: _cinNumberController.text.trim(),
          cinIssueDate: _cinIssueDate ?? DateTime.now(),
          cinIssuePlace: _cinIssuePlaceController.text.trim(),
          cinScanUrl: _cinScanUrl ?? '',
          isSingle: _isSingle,
          isMarried: _isMarried,
          numberOfChildren: int.tryParse(_numberOfChildrenController.text) ?? 0,
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          photoIdUrl: _photoIdUrl ?? '',
          responsibilities: _responsibilitiesController.text.trim(),
          hireDate: _hireDate ?? DateTime.now(),
          diplomas: _diplomas,
          educationLevel: _educationLevelController.text.trim(),
          professionalTraining: _professionalTraining,
          professionalExperience: _professionalExperience,
          emergencyContactName: _emergencyContactNameController.text.trim(),
          emergencyContactRelation: _emergencyContactRelationController.text.trim(),
          emergencyContactPhone: _emergencyContactPhoneController.text.trim(),
          emergencyContactEmail: _emergencyContactEmailController.text.trim(),
          hasSpecialAdvance: _hasSpecialAdvance,
          specialAdvanceAmount: double.tryParse(_specialAdvanceAmountController.text) ?? 0,
          specialAdvanceDate: _specialAdvanceDate ?? DateTime.now(),
          specialAdvanceFirstRepaymentDate: _specialAdvanceFirstRepaymentDate ?? DateTime.now(),
          specialAdvanceWeeklyAmount: double.tryParse(_specialAdvanceWeeklyAmountController.text) ?? 0,
          specialAdvanceMonthlyAmount: double.tryParse(_specialAdvanceMonthlyAmountController.text) ?? 0,
          hasPunctualAdvance: _hasPunctualAdvance,
          punctualAdvanceAmount: double.tryParse(_punctualAdvanceAmountController.text) ?? 0,
          punctualAdvanceDate: _punctualAdvanceDate ?? DateTime.now(),
          punctualAdvanceRepaymentDate: _punctualAdvanceRepaymentDate ?? DateTime.now(),
          absences: _absences,
          paymentType: _paymentType,
          dailyRate: double.tryParse(_dailyRateController.text) ?? 0,
          weeklyRate: double.tryParse(_weeklyRateController.text) ?? 0,
          monthlyRate: double.tryParse(_monthlyRateController.text) ?? 0,
          unpaidWeeks: widget.worker?.unpaidWeeks ?? {},
          advanceAmount: 0, // TODO: Calculate based on advances
          advanceNextWeek: false,
        );

        if (widget.worker == null) {
          await _workerService.addWorker(worker);
        } else {
          await _workerService.updateWorker(worker);
        }

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    }
  }
}

class _AddAbsenceDialog extends StatefulWidget {
  @override
  State<_AddAbsenceDialog> createState() => _AddAbsenceDialogState();
}

class _AddAbsenceDialogState extends State<_AddAbsenceDialog> {
  DateTime? _date;
  final _durationController = TextEditingController();
  final _remunerationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle absence'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(_date == null ? 'Date' : DateFormat('yyyy-MM-dd').format(_date!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Durée (jours)'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
            ),
            TextFormField(
              controller: _remunerationController,
              decoration: const InputDecoration(labelText: 'Rémunération (Ariary)'),
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
          onPressed: () {
            if (_formKey.currentState!.validate() && _date != null) {
              Navigator.pop(
                context,
                Absence(
                  date: _date!,
                  durationDays: int.tryParse(_durationController.text) ?? 1,
                  remuneration: double.tryParse(_remunerationController.text) ?? 0,
                ),
              );
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
} 