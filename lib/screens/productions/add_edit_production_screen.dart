import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class AddEditProductionScreen extends StatefulWidget {
  const AddEditProductionScreen({super.key});

  @override
  State<AddEditProductionScreen> createState() => _AddEditProductionScreenState();
}

class _AddEditProductionScreenState extends State<AddEditProductionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _metersController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedShift = 'Day';
  String? _selectedMachine;
  String? _selectedWorker;
  String? _selectedTaka;

  // Dummy Data for Dropdowns
  final List<String> _machines = ['Loom 01', 'Loom 02', 'Loom 03', 'Loom 04'];
  final List<String> _workers = ['Ram Kumar', 'Shyam Singh', 'Mohan Lal'];
  final List<String> _takas = ['Taka-101', 'Taka-102', 'Taka-103'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Production'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Picker
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    "${_selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Shift Dropdown
              DropdownButtonFormField<String>(
                value: _selectedShift,
                decoration: const InputDecoration(
                  labelText: 'Shift',
                  border: OutlineInputBorder(),
                ),
                items: ['Day', 'Night'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedShift = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Machine Dropdown
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

              // Worker Dropdown
              DropdownButtonFormField<String>(
                value: _selectedWorker,
                decoration: const InputDecoration(
                  labelText: 'Worker',
                  border: OutlineInputBorder(),
                ),
                items: _workers.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedWorker = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a worker' : null,
              ),
              const SizedBox(height: 16),

              // Taka Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTaka,
                decoration: const InputDecoration(
                  labelText: 'Taka',
                  border: OutlineInputBorder(),
                ),
                items: _takas.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedTaka = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a taka' : null,
              ),
              const SizedBox(height: 16),

              // Meters Input
              CustomTextField(
                controller: _metersController,
                label: 'Meters Produced',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter meters produced';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              GradientButton(
                text: 'Save Production',
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
    _metersController.dispose();
    super.dispose();
  }
}
