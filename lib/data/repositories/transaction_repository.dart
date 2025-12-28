import '../models/transaction_model.dart';
import '../data sources/remote/transaction_remote_data_source.dart';

class TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepository({TransactionRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? TransactionRemoteDataSource();

  Future<List<TransactionModel>> getTransactions() async {
    try {
      return await _remoteDataSource.fetchTransactions();
    } catch (e) {
      throw Exception('Failed to fetch transactions: ${e.toString()}');
    }
  }

  Future<TransactionModel> getTransactionById(String id) async {
    try {
      return await _remoteDataSource.fetchTransactionById(id);
    } catch (e) {
      throw Exception('Failed to fetch transaction: ${e.toString()}');
    }
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      await _remoteDataSource.createTransaction(transaction);
    } catch (e) {
      throw Exception('Failed to create transaction: ${e.toString()}');
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _remoteDataSource.updateTransaction(transaction);
    } catch (e) {
      throw Exception('Failed to update transaction: ${e.toString()}');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _remoteDataSource.deleteTransaction(id);
    } catch (e) {
      throw Exception('Failed to delete transaction: ${e.toString()}');
    }
  }
}
