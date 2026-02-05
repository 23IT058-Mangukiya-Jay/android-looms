import 'package:cloud_firestore/cloud_firestore.dart';

class Machine {
  final String id;
  final String machineCode;
  final String machineName;
  final String machineType;
  final String status;
  final String location;
  final DateTime? installationDate;
  final String notes;

  Machine({
    required this.id,
    required this.machineCode,
    required this.machineName,
    required this.machineType,
    required this.status,
    required this.location,
    this.installationDate,
    required this.notes,
  });

  factory Machine.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Machine(
      id: doc.id,
      machineCode: data['machineCode'] ?? '',
      machineName: data['machineName'] ?? '',
      machineType: data['machineType'] ?? '',
      status: data['status'] ?? 'Active',
      location: data['location'] ?? '',
      installationDate: data['installationDate'] != null
          ? (data['installationDate'] as Timestamp).toDate()
          : null,
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'machineCode': machineCode,
      'machineName': machineName,
      'machineType': machineType,
      'status': status,
      'location': location,
      'installationDate': installationDate != null
          ? Timestamp.fromDate(installationDate!)
          : null,
      'notes': notes,
    };
  }
}
