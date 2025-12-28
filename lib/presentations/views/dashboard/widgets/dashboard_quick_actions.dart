import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';

class DashboardQuickActions extends StatelessWidget {
  final VoidCallback onNewTransaction;
  final VoidCallback onExportData;
  final VoidCallback onViewReports;
  final VoidCallback onSettings;

  const DashboardQuickActions({
    super.key,
    required this.onNewTransaction,
    required this.onExportData,
    required this.onViewReports,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: Icons.add_circle_outline,
                label: 'New\nTransaction',
                color: AppColors.primary,
                onTap: onNewTransaction,
              ),
              _ActionButton(
                icon: Icons.file_download_outlined,
                label: 'Export\nData',
                color: Colors.green,
                onTap: onExportData,
              ),
              _ActionButton(
                icon: Icons.insights_outlined,
                label: 'View\nReports',
                color: Colors.orange,
                onTap: onViewReports,
              ),
              _ActionButton(
                icon: Icons.settings_outlined,
                label: 'Settings',
                color: Colors.grey,
                onTap: onSettings,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
