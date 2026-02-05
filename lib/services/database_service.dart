import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/machine_model.dart';

class DatabaseService {
  final CollectionReference _machineCollection =
      FirebaseFirestore.instance.collection('machines');

  // Create
  Future<void> addMachine(Machine machine) {
    return _machineCollection.add(machine.toMap());
  }

  // Read
  Stream<List<Machine>> getMachines() {
    return _machineCollection
        .orderBy('machineCode', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Machine.fromFirestore(doc);
      }).toList();
    });
  }

  // Update
  Future<void> updateMachine(Machine machine) {
    return _machineCollection.doc(machine.id).update(machine.toMap());
  }

  // Delete
  Future<void> deleteMachine(String id) {
    return _machineCollection.doc(id).delete();
  }
}
