class TransactionModel {
  final String id;
  final double amount;
  final DateTime date;
  final String payerName;
  final String status;
  final String? description;
  final String? paymentMethod;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.payerName,
    required this.status,
    this.description,
    this.paymentMethod,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      payerName: json['payerName'] ?? '',
      status: json['status'] ?? 'pending',
      description: json['description'],
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'payerName': payerName,
      'status': status,
      'description': description,
      'paymentMethod': paymentMethod,
    };
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    DateTime? date,
    String? payerName,
    String? status,
    String? description,
    String? paymentMethod,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      payerName: payerName ?? this.payerName,
      status: status ?? this.status,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}