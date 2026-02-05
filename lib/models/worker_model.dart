class Worker {
  final String id;
  final String name;
  final String workerCode;
  final String workerType; // Permanent, Temporary
  final String shift; // Day, Night, Both, None
  final String? phone;
  final String? address;

  Worker({
    required this.id,
    required this.name,
    required this.workerCode,
    required this.workerType,
    required this.shift,
    this.phone,
    this.address,
  });
}
