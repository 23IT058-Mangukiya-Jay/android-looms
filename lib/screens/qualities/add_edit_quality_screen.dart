import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class AddEditQualityScreen extends StatefulWidget {
  final String? qualityId;
  const AddEditQualityScreen({super.key, this.qualityId});

  @override
  State<AddEditQualityScreen> createState() => _AddEditQualityScreenState();
}

class _AddEditQualityScreenState extends State<AddEditQualityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rateController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.qualityId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Quality' : 'Add Quality'),
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
                label: 'Quality Name',
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _rateController,
                label: 'Rate per Meter (₹)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter rate';
                  if (double.tryParse(value) == null) return 'Invalid rate';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              GradientButton(
                text: isEditing ? 'Update Quality' : 'Save Quality',
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
    _rateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
