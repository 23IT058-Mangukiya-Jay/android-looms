import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../models/production_model.dart';

class AddEditProductionScreen extends StatefulWidget {
  final Production? production;

  const AddEditProductionScreen({super.key, this.production});

  @override
  State<AddEditProductionScreen> createState() => _AddEditProductionScreenState();
}

class _AddEditProductionScreenState extends State<AddEditProductionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _metersController = TextEditingController();
  final _machineController = TextEditingController();
  final _workerController = TextEditingController();
  final _takaController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedShift = 'Day';

  @override
  void initState() {
    super.initState();
    if (widget.production != null) {
      _metersController.text = widget.production!.metersProduced.toString();
      _machineController.text = widget.production!.machineName;
      _workerController.text = widget.production!.workerName;
      _takaController.text = widget.production!.takaNumber;
      _selectedDate = widget.production!.date;
      _selectedShift = widget.production!.shift;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.production == null ? 'Record Production' : 'Edit Production'),
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

              // Machine Input
              CustomTextField(
                controller: _machineController,
                label: 'Machine Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a machine name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Worker Input
              CustomTextField(
                controller: _workerController,
                label: 'Worker Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a worker name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Taka Input
              CustomTextField(
                controller: _takaController,
                label: 'Taka Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a taka number';
                  }
                  return null;
                },
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
                    final meters = double.parse(_metersController.text);
                    final updatedProduction = Production(
                      id: widget.production?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      date: _selectedDate,
                      machineId: 'm3', // dummy machine id
                      machineName: _machineController.text,
                      workerId: 'w3', // dummy worker id
                      workerName: _workerController.text,
                      takaId: 't3', // dummy taka id
                      takaNumber: _takaController.text,
                      shift: _selectedShift,
                      metersProduced: meters,
                      earnings: meters * 10.0, // dummy calculation for earnings
                    );
                    Navigator.pop(context, updatedProduction);
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
    _machineController.dispose();
    _workerController.dispose();
    _takaController.dispose();
    super.dispose();
  }
}
