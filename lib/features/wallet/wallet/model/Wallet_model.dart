class WalletResponse {
  final List<Transaction> transactions;
  final String status;
  final String message;
  final int wallet;

  WalletResponse({
    required this.transactions,
    required this.status,
    required this.message,
    required this.wallet,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      transactions: (json['data'] as List)
          .map((item) => Transaction.fromJson(item))
          .toList(),
      status: json['status'],
      message: json['message'],
      wallet: json['wallet'],
    );
  }
}

class Transaction {
  final int id;
  final int amount;
  final int beforeCharge;
  final int afterCharge;
  final String date;
  final String statusTrans;
  final String status;
  final String transactionType;
  final String modelType;
  final int modelId;
  final String state;

  Transaction({
    required this.id,
    required this.amount,
    required this.beforeCharge,
    required this.afterCharge,
    required this.date,
    required this.statusTrans,
    required this.status,
    required this.transactionType,
    required this.modelType,
    required this.modelId,
    required this.state,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      beforeCharge: json['before_charge'],
      afterCharge: json['after_charge'],
      date: json['date'],
      statusTrans: json['status_trans'],
      status: json['status'],
      transactionType: json['transaction_type'],
      modelType: json['model_type'],
      modelId: json['model_id'],
      state: json['state'],
    );
  }
}