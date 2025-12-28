import '../../models/transaction_model.dart';

class TransactionRemoteDataSource {
  Future<void> _delay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  // Mock transaction data
  List<TransactionModel> _getMockTransactions() {
    final now = DateTime.now();
    return [
      TransactionModel(
        id: '1',
        amount: 1250.00,
        date: now.subtract(const Duration(hours: 2)),
        payerName: 'John Smith',
        status: 'completed',
        description: 'Payment for services',
        paymentMethod: 'Credit Card',
      ),
      TransactionModel(
        id: '2',
        amount: 850.50,
        date: now.subtract(const Duration(days: 1)),
        payerName: 'Sarah Johnson',
        status: 'completed',
        description: 'Product purchase',
        paymentMethod: 'PayPal',
      ),
      TransactionModel(
        id: '3',
        amount: 2100.00,
        date: now.subtract(const Duration(days: 1, hours: 5)),
        payerName: 'Michael Brown',
        status: 'pending',
        description: 'Consultation fee',
        paymentMethod: 'Bank Transfer',
      ),
      TransactionModel(
        id: '4',
        amount: 450.75,
        date: now.subtract(const Duration(days: 2)),
        payerName: 'Emily Davis',
        status: 'completed',
        description: 'Monthly subscription',
        paymentMethod: 'Credit Card',
      ),
      TransactionModel(
        id: '5',
        amount: 3200.00,
        date: now.subtract(const Duration(days: 3)),
        payerName: 'David Wilson',
        status: 'completed',
        description: 'Project milestone',
        paymentMethod: 'Wire Transfer',
      ),
      TransactionModel(
        id: '6',
        amount: 675.25,
        date: now.subtract(const Duration(days: 4)),
        payerName: 'Jennifer Taylor',
        status: 'completed',
        description: 'Service payment',
        paymentMethod: 'Credit Card',
      ),
      TransactionModel(
        id: '7',
        amount: 920.00,
        date: now.subtract(const Duration(days: 5)),
        payerName: 'Robert Martinez',
        status: 'failed',
        description: 'Product order',
        paymentMethod: 'Debit Card',
      ),
      TransactionModel(
        id: '8',
        amount: 1540.50,
        date: now.subtract(const Duration(days: 5)),
        payerName: 'Lisa Anderson',
        status: 'completed',
        description: 'Consulting services',
        paymentMethod: 'PayPal',
      ),
      TransactionModel(
        id: '9',
        amount: 780.00,
        date: now.subtract(const Duration(days: 6)),
        payerName: 'James Thomas',
        status: 'completed',
        description: 'Annual membership',
        paymentMethod: 'Credit Card',
      ),
      TransactionModel(
        id: '10',
        amount: 1125.75,
        date: now.subtract(const Duration(days: 6)),
        payerName: 'Maria Garcia',
        status: 'pending',
        description: 'Design work',
        paymentMethod: 'Bank Transfer',
      ),
    ];
  }

  Future<List<TransactionModel>> fetchTransactions() async {
    await _delay();
    return _getMockTransactions();
  }

  Future<TransactionModel> fetchTransactionById(String id) async {
    await _delay();
    final transactions = _getMockTransactions();
    return transactions.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    await _delay();
    // In real app: API call to create transaction
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _delay();
    // In real app: API call to update transaction
  }

  Future<void> deleteTransaction(String id) async {
    await _delay();
    // In real app: API call to delete transaction
  }
}
