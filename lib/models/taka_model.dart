class Taka {
  final String id;
  final String takaNumber;
  final String machineId;
  final String machineName;
  final String qualityId;
  final String qualityName;
  final double targetMeters;
  final double totalMeters;
  final double ratePerMeter;
  final String status; // Active, Completed, Pending
  final double totalEarnings;
  final DateTime? startDate;
  final DateTime? endDate;

  Taka({
    required this.id,
    required this.takaNumber,
    required this.machineId,
    required this.machineName,
    required this.qualityId,
    required this.qualityName,
    required this.targetMeters,
    required this.totalMeters,
    required this.ratePerMeter,
    required this.status,
    required this.totalEarnings,
    this.startDate,
    this.endDate,
  });
}
