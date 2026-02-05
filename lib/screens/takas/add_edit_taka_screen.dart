import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class AddEditTakaScreen extends StatefulWidget {
  final String? takaId;
  const AddEditTakaScreen({super.key, this.takaId});

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
  Widget build(BuildContext context) {
    final isEditing = widget.takaId != null;

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    Navigator.pop(context);
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
