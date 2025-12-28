import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'transaction_detail_screen.dart';

class TransactionListScreen extends StatefulWidget {
  final String? statusFilter;

  const TransactionListScreen({super.key, this.statusFilter});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  late Future<List<TransactionModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = TransactionRepository().getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final String title;
    if (widget.statusFilter == null) {
      title = 'Transactions';
    } else {
      final status = widget.statusFilter!;
      final lowercase = status.toLowerCase();
      final capitalized = lowercase.isEmpty
          ? lowercase
          : lowercase[0].toUpperCase() + lowercase.substring(1);
      title = '$capitalized transactions';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load transactions',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 14,
                ),
              ),
            );
          }

          var transactions = snapshot.data ?? <TransactionModel>[];

          if (widget.statusFilter != null) {
            final status = widget.statusFilter!.toLowerCase();
            transactions = transactions
                .where((t) => t.status.toLowerCase() == status)
                .toList();
          }

          if (transactions.isEmpty) {
            return const Center(
              child: Text('No transactions found'),
            );
          }

          return ListView.separated(
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.shade200,
            ),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionDetailScreen(
                        transactionId: transaction.id,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor:
                      _statusColor(transaction.status).withAlpha(25),
                  child: Icon(
                    _statusIcon(transaction.status),
                    color: _statusColor(transaction.status),
                  ),
                ),
                title: Text(
                  transaction.payerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  DateFormatter.formatRelative(transaction.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.format(transaction.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _statusBadge(transaction.status),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'failed':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

