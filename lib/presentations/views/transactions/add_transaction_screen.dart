import 'package:flutter/material.dart';

import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _payerController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _paymentMethodController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _payerController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _paymentMethodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _payerController,
                decoration: const InputDecoration(
                  labelText: 'Payer name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a payer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final parsed = double.tryParse(value.replaceAll(',', ''));
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(
                  labelText: 'Payment method',
                  hintText: 'e.g. Credit Card, Bank Transfer',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  icon: const Icon(Icons.check),
                  label: Text(_isSubmitting ? 'Saving...' : 'Save Transaction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final amount =
          double.parse(_amountController.text.replaceAll(',', '').trim());
      final now = DateTime.now();

      final transaction = TransactionModel(
        id: now.millisecondsSinceEpoch.toString(),
        amount: amount,
        date: now,
        payerName: _payerController.text.trim(),
        status: 'completed',
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        paymentMethod: _paymentMethodController.text.trim().isEmpty
            ? null
            : _paymentMethodController.text.trim(),
      );

      await TransactionRepository().createTransaction(transaction);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction saved (mock)'),
        ),
      );

      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

