import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class AddEditWorkerScreen extends StatefulWidget {
  final String? workerId;
  const AddEditWorkerScreen({super.key, this.workerId});

  @override
  State<AddEditWorkerScreen> createState() => _AddEditWorkerScreenState();
}

class _AddEditWorkerScreenState extends State<AddEditWorkerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _workerType = 'Permanent';
  String _shift = 'Day';

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.workerId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Worker' : 'Add New Worker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Worker Name',
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _codeController,
                label: 'Worker Code',
                validator: (value) => value!.isEmpty ? 'Please enter code' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _workerType,
                decoration: const InputDecoration(labelText: 'Worker Type', border: OutlineInputBorder()),
                items: ['Permanent', 'Temporary'].map((String value) {
                  return DropdownMenuItem<String>( value: value, child: Text(value) );
                }).toList(),
                onChanged: (newValue) => setState(() => _workerType = newValue!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _shift,
                decoration: const InputDecoration(labelText: 'Shift', border: OutlineInputBorder()),
                 items: ['Day', 'Night', 'Both', 'None'].map((String value) {
                  return DropdownMenuItem<String>( value: value, child: Text(value) );
                }).toList(),
                onChanged: (newValue) => setState(() => _shift = newValue!),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _phoneController,
                label: 'Phone (Optional)',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _addressController,
                label: 'Address (Optional)',
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              GradientButton(
                text: isEditing ? 'Update Worker' : 'Create Worker',
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
    _nameController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
