import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/gradient_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTimeRange? _selectedDateRange;
  String _reportType = 'Production';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Select Date Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_selectedDateRange == null 
                          ? 'Choose Dates' 
                          : '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}'),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDateRange = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _reportType,
              decoration: const InputDecoration(labelText: 'Report Type', border: OutlineInputBorder()),
              items: ['Production', 'Workers', 'Takas', 'Earnings'].map((String value) {
                return DropdownMenuItem<String>( value: value, child: Text(value) );
              }).toList(),
              onChanged: (newValue) => setState(() => _reportType = newValue!),
            ),
            const SizedBox(height: 24),
            
            GradientButton(
              text: 'Generate Report',
              onPressed: () {
                if (_selectedDateRange == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a date range')),
                  );
                  return;
                }
                // Mock Generation
                showDialog(
                  context: context, 
                  builder: (ctx) => AlertDialog(
                    title: const Text('Report Generated'),
                    content: Text('Generated $_reportType report for ${_selectedDateRange!.start.toString().split(' ')[0]} to ${_selectedDateRange!.end.toString().split(' ')[0]}'),
                    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
