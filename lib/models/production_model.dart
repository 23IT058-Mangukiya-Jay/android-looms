class Production {
  final String id;
  final DateTime date;
  final String machineId;
  final String machineName;
  final String workerId;
  final String workerName;
  final String takaId;
  final String takaNumber;
  final String shift;
  final double metersProduced;
  final double earnings;

  Production({
    required this.id,
    required this.date,
    required this.machineId,
    required this.machineName,
    required this.workerId,
    required this.workerName,
    required this.takaId,
    required this.takaNumber,
    required this.shift,
    required this.metersProduced,
    required this.earnings,
  });
}
