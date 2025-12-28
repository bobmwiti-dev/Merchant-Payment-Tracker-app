import 'package:flutter/foundation.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'dashboard_state.dart';

class DashboardViewModel extends ChangeNotifier {
  final TransactionRepository _transactionRepository;

  DashboardState _state = const DashboardInitial();
  List<TransactionModel> _transactions = [];

  DashboardViewModel({TransactionRepository? transactionRepository})
      : _transactionRepository = transactionRepository ?? TransactionRepository();

  DashboardState get state => _state;

  List<TransactionModel> get recentTransactions {
    if (_transactions.length <= 5) {
      return List.unmodifiable(_transactions);
    }
    return List.unmodifiable(_transactions.take(5));
  }

  Future<void> loadDashboard() async {
    _setState(const DashboardLoadingState());

    try {
      final transactions = await _transactionRepository.getTransactions();
      _transactions = transactions;

      final data = _buildDashboardData(transactions);
      _setState(DashboardLoaded(data));
    } catch (e) {
      _setState(DashboardErrorState(e.toString()));
    }
  }

  void _setState(DashboardState newState) {
    _state = newState;
    notifyListeners();
  }

  DashboardData _buildDashboardData(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return const DashboardData(
        totalEarnings: 0,
        totalTransactions: 0,
        completedCount: 0,
        pendingAmount: 0,
        pendingCount: 0,
        monthlyEarnings: 0,
        chartData: [],
      );
    }

    final completed = transactions
        .where((t) => t.status.toLowerCase() == 'completed')
        .toList();
    final pending = transactions
        .where((t) => t.status.toLowerCase() == 'pending')
        .toList();

    final totalEarnings = completed.fold<double>(
      0,
      (sum, t) => sum + t.amount,
    );

    final pendingAmount = pending.fold<double>(
      0,
      (sum, t) => sum + t.amount,
    );

    final now = DateTime.now();
    final monthlyCompleted = completed.where(
      (t) => t.date.year == now.year && t.date.month == now.month,
    );
    final monthlyEarnings = monthlyCompleted.fold<double>(
      0,
      (sum, t) => sum + t.amount,
    );

    final totalsByDay = <String, double>{};
    final sevenDaysAgo = now.subtract(const Duration(days: 6));

    for (final t in completed) {
      if (t.date.isBefore(sevenDaysAgo)) continue;
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      final label = DateFormatter.formatShort(day);
      totalsByDay[label] = (totalsByDay[label] ?? 0) + t.amount;
    }

    final chartPoints = totalsByDay.entries
        .map(
          (e) => DashboardChartPoint(
            label: e.key,
            value: e.value,
          ),
        )
        .toList();

    return DashboardData(
      totalEarnings: totalEarnings,
      totalTransactions: transactions.length,
      completedCount: completed.length,
      pendingAmount: pendingAmount,
      pendingCount: pending.length,
      monthlyEarnings: monthlyEarnings,
      chartData: chartPoints,
    );
  }
}