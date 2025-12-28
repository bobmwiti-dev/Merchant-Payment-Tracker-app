import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    final repository = TransactionRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: FutureBuilder<TransactionModel>(
        future: repository.getTransactionById(transactionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load transaction',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 14,
                ),
              ),
            );
          }

          final transaction = snapshot.data;
          if (transaction == null) {
            return const Center(child: Text('Transaction not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CurrencyFormatter.format(transaction.amount),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  transaction.payerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormatter.formatDateTime(transaction.date),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _statusChip(transaction.status),
                    const SizedBox(width: 8),
                    if (transaction.paymentMethod != null)
                      Chip(
                        label: Text(transaction.paymentMethod!),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (transaction.description != null &&
                    transaction.description!.isNotEmpty) ...[
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.description!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      backgroundColor: color.withAlpha(25),
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
}

