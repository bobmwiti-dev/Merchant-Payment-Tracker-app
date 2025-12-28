import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth/auth_viewmodel.dart';
import '../../viewmodels/dashboard/dashboard_state.dart';
import '../../viewmodels/dashboard/dashboard_viewmodel.dart';
import '../transactions/add_transaction_screen.dart';
import '../transactions/transaction_detail_screen.dart';
import '../transactions/transaction_list_screen.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/dashboard_chart_section.dart';
import 'widgets/dashboard_error.dart';
import 'widgets/dashboard_loading.dart';
import 'widgets/dashboard_quick_actions.dart';
import 'widgets/dashboard_recent_transactions.dart';
import 'widgets/dashboard_summary_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: DashboardAppBar(
        onNotificationTap: () {
          // TODO: implement notifications
        },
        onLogoutTap: () async {
          await context.read<AuthViewModel>().signOut();
          if (context.mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          final state = viewModel.state;

          if (state is DashboardInitial || state is DashboardLoadingState) {
            return const DashboardLoading();
          }

          if (state is DashboardErrorState) {
            return DashboardError(
              message: state.message,
              onRetry: viewModel.loadDashboard,
            );
          }

          if (state is DashboardLoaded) {
            final data = state.data;
            final recentTransactions = viewModel.recentTransactions;

            return RefreshIndicator(
              onRefresh: viewModel.loadDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DashboardSummarySection(data: data),
                        const SizedBox(height: 16),
                        DashboardChartSection(data: data),
                        const SizedBox(height: 16),
                        DashboardQuickActions(
                          onNewTransaction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddTransactionScreen(),
                              ),
                            );
                          },
                          onExportData: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.file_download),
                                        title: const Text('Export as CSV'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Export as CSV coming soon',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.picture_as_pdf),
                                        title: const Text('Export as PDF'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Export as PDF coming soon',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          onViewReports: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reports screen coming soon'),
                              ),
                            );
                          },
                          onSettings: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Settings screen coming soon'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        DashboardRecentTransactions(
                          transactions: recentTransactions,
                          onSeeAll: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TransactionListScreen(),
                              ),
                            );
                          },
                          onTransactionTap: (id) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TransactionDetailScreen(
                                  transactionId: id,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}