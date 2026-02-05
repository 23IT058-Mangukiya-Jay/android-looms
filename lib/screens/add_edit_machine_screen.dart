import 'package:flutter/material.dart';
import '../models/machine_model.dart';
import '../services/database_service.dart';

class AddEditMachineScreen extends StatefulWidget {
  final Machine? machine;

  const AddEditMachineScreen({super.key, this.machine});

  @override
  State<AddEditMachineScreen> createState() => _AddEditMachineScreenState();
}

class _AddEditMachineScreenState extends State<AddEditMachineScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _machineCodeController;
  late TextEditingController _machineNameController;
  late TextEditingController _machineTypeController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  String _status = 'Active';

  bool _isLoading = false;

  final List<String> _statusOptions = [
    'Active',
    'Inactive',
    'Maintenance',
    'Broken'
  ];

  @override
  void initState() {
    super.initState();
    _machineCodeController =
        TextEditingController(text: widget.machine?.machineCode ?? '');
    _machineNameController =
        TextEditingController(text: widget.machine?.machineName ?? '');
    _machineTypeController =
        TextEditingController(text: widget.machine?.machineType ?? '');
    _locationController =
        TextEditingController(text: widget.machine?.location ?? '');
    _notesController = TextEditingController(text: widget.machine?.notes ?? '');
    _status = widget.machine?.status ?? 'Active';
  }

  @override
  void dispose() {
    _machineCodeController.dispose();
    _machineNameController.dispose();
    _machineTypeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveMachine() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final machine = Machine(
        id: widget.machine?.id ?? '', // ID is ignored/generated for new items
        machineCode: _machineCodeController.text.trim(),
        machineName: _machineNameController.text.trim(),
        machineType: _machineTypeController.text.trim(),
        status: _status,
        location: _locationController.text.trim(),
        notes: _notesController.text.trim(),
        installationDate: widget.machine?.installationDate ?? DateTime.now(),
      );

      if (widget.machine == null) {
        await DatabaseService().addMachine(machine);
      } else {
        await DatabaseService().updateMachine(machine);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Machine ${widget.machine == null ? 'added' : 'updated'} successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.machine == null ? 'Add Machine' : 'Edit Machine'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _machineCodeController,
                      decoration: const InputDecoration(labelText: 'Machine Code'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter machine code' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _machineNameController,
                      decoration: const InputDecoration(labelText: 'Machine Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter machine name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _machineTypeController,
                      decoration: const InputDecoration(labelText: 'Machine Type'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: _statusOptions.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _status = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveMachine,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Save Machine'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
