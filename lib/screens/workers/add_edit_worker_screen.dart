import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../models/worker_model.dart';

class AddEditWorkerScreen extends StatefulWidget {
  final Worker? worker;
  const AddEditWorkerScreen({super.key, this.worker});

  @override
  State<AddEditWorkerScreen> createState() => _AddEditWorkerScreenState();
}

class _AddEditWorkerScreenState extends State<AddEditWorkerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _workerTypeController = TextEditingController();
  final _shiftController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.worker != null) {
      _nameController.text = widget.worker!.name;
      _codeController.text = widget.worker!.workerCode;
      _phoneController.text = widget.worker!.phone ?? '';
      _addressController.text = widget.worker!.address ?? '';
      _workerTypeController.text = widget.worker!.workerType;
      _shiftController.text = widget.worker!.shift;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.worker != null;

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
              CustomTextField(
                controller: _workerTypeController,
                label: 'Worker Type (e.g. Permanent, Temporary, Sub-contract)',
                validator: (value) => value!.isEmpty ? 'Please enter worker type' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _shiftController,
                label: 'Shift (e.g. Day, Night, Part-Time)',
                validator: (value) => value!.isEmpty ? 'Please enter shift' : null,
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
                    final newWorker = Worker(
                      id: isEditing ? widget.worker!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      workerCode: _codeController.text,
                      workerType: _workerTypeController.text,
                      shift: _shiftController.text,
                      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
                      address: _addressController.text.isEmpty ? null : _addressController.text,
                    );
                    Navigator.pop(context, newWorker);
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
    _workerTypeController.dispose();
    _shiftController.dispose();
    super.dispose();
  }
}
