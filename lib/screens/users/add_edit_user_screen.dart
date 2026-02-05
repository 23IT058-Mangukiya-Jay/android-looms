import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class AddEditUserScreen extends StatefulWidget {
  final String? userId; // If null, create mode
  const AddEditUserScreen({super.key, this.userId});

  @override
  State<AddEditUserScreen> createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _role = 'manager';

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.userId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit User' : 'Add New User'),
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
                label: 'Name',
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Please enter email' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _passwordController,
                label: isEditing ? 'Password (leave blank to keep)' : 'Password',
                obscureText: true,
                validator: (value) {
                  if (!isEditing && (value == null || value.isEmpty)) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
                 items: ['owner', 'manager'].map((String value) {
                  return DropdownMenuItem<String>( value: value, child: Text(value) );
                }).toList(),
                onChanged: (newValue) => setState(() => _role = newValue!),
              ),
              const SizedBox(height: 24),

              GradientButton(
                text: isEditing ? 'Update User' : 'Create User',
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
