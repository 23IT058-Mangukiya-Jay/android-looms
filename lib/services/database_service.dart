import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/machine_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the current authenticated user's UID, or throws if not logged in.
  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  /// Reference to the machines collection scoped to the current user.
  CollectionReference get _machineCollection =>
      _db.collection('users').doc(_uid).collection('machines');

  // ── Create ──────────────────────────────────────────────────────────────────
  Future<void> addMachine(Machine machine) {
    return _machineCollection.add(machine.toMap());
  }

  // ── Read ────────────────────────────────────────────────────────────────────
  Stream<List<Machine>> getMachines() {
    return _machineCollection
        .orderBy('machineCode', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Machine.fromFirestore(doc)).toList());
  }

  // ── Update ──────────────────────────────────────────────────────────────────
  Future<void> updateMachine(Machine machine) {
    return _machineCollection.doc(machine.id).update(machine.toMap());
  }

  // ── Delete ──────────────────────────────────────────────────────────────────
  Future<void> deleteMachine(String id) {
    return _machineCollection.doc(id).delete();
  }
}
