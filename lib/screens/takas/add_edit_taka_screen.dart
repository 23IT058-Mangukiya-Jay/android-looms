import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../models/taka_model.dart';

class AddEditTakaScreen extends StatefulWidget {
  final Taka? taka;
  const AddEditTakaScreen({super.key, this.taka});

  @override
  State<AddEditTakaScreen> createState() => _AddEditTakaScreenState();
}

class _AddEditTakaScreenState extends State<AddEditTakaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _takaNumberController = TextEditingController();
  final _targetMetersController = TextEditingController();
  final _rateController = TextEditingController();
  
  String? _selectedMachine;
  String? _selectedQuality;
  String _status = 'Pending';
  
  // Dummy Data
  final List<String> _machines = ['Loom 01', 'Loom 02', 'Loom 03'];
  final List<String> _qualities = ['Cotton 60s', 'Polyester 40s'];

  @override
  void initState() {
    super.initState();
    if (widget.taka != null) {
      _takaNumberController.text = widget.taka!.takaNumber;
      _targetMetersController.text = widget.taka!.targetMeters.toString();
      _rateController.text = widget.taka!.ratePerMeter.toString();
      _selectedMachine = widget.taka!.machineName;
      _selectedQuality = widget.taka!.qualityName;
      _status = widget.taka!.status;
      if (!_machines.contains(_selectedMachine)) _selectedMachine = null;
      if (!_qualities.contains(_selectedQuality)) _selectedQuality = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taka != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Taka' : 'Add New Taka'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _takaNumberController,
                label: 'Taka Number',
                validator: (value) => value!.isEmpty ? 'Please enter taka number' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedMachine,
                decoration: const InputDecoration(
                  labelText: 'Machine',
                  border: OutlineInputBorder(),
                ),
                items: _machines.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMachine = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a machine' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedQuality,
                decoration: const InputDecoration(
                  labelText: 'Quality Type',
                  border: OutlineInputBorder(),
                ),
                items: _qualities.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedQuality = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a quality' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _rateController,
                label: 'Rate per Meter',
                keyboardType: TextInputType.number,
                 validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter rate';
                  if (double.tryParse(value) == null) return 'Invalid rate';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _targetMetersController,
                label: 'Target Meters',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter target';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Pending', 'Active', 'Completed', 'Cancelled'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              GradientButton(
                text: isEditing ? 'Update Taka' : 'Create Taka',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final target = double.parse(_targetMetersController.text);
                    final rate = double.parse(_rateController.text);
                    
                    final newTaka = Taka(
                      id: isEditing ? widget.taka!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                      takaNumber: _takaNumberController.text,
                      machineId: 'm1', // dummy
                      machineName: _selectedMachine!,
                      qualityId: 'q1', // dummy
                      qualityName: _selectedQuality!,
                      targetMeters: target,
                      totalMeters: isEditing ? widget.taka!.totalMeters : 0.0,
                      ratePerMeter: rate,
                      status: _status,
                      totalEarnings: isEditing ? widget.taka!.totalEarnings : 0.0,
                      startDate: isEditing ? widget.taka!.startDate : DateTime.now(),
                      endDate: isEditing ? widget.taka!.endDate : null,
                    );
                    Navigator.pop(context, newTaka);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _takaNumberController.dispose();
    _targetMetersController.dispose();
    _rateController.dispose();
    super.dispose();
  }
}
