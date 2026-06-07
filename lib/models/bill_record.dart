class BillRecord {
  final int? id;
  final String month;
  final double units;
  final double totalCharges;
  final double rebatePercent;
  final double finalCost;

  BillRecord({
    this.id,
    required this.month,
    required this.units,
    required this.totalCharges,
    required this.rebatePercent,
    required this.finalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'units': units,
      'totalCharges': totalCharges,
      'rebatePercent': rebatePercent,
      'finalCost': finalCost,
    };
  }

  factory BillRecord.fromMap(Map<String, dynamic> map) {
    return BillRecord(
      id: map['id'],
      month: map['month'],
      units: map['units'],
      totalCharges: map['totalCharges'],
      rebatePercent: map['rebatePercent'],
      finalCost: map['finalCost'],
    );
  }
}