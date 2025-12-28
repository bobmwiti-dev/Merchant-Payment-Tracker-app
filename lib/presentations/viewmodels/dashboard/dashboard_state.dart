class DashboardChartPoint {
  final String label;
  final double value;

  const DashboardChartPoint({
    required this.label,
    required this.value,
  });
}

class DashboardData {
  final double totalEarnings;
  final int totalTransactions;
  final int completedCount;
  final double pendingAmount;
  final int pendingCount;
  final double monthlyEarnings;
  final List<DashboardChartPoint> chartData;

  const DashboardData({
    required this.totalEarnings,
    required this.totalTransactions,
    required this.completedCount,
    required this.pendingAmount,
    required this.pendingCount,
    required this.monthlyEarnings,
    required this.chartData,
  });
}

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoadingState extends DashboardState {
  const DashboardLoadingState();
}

class DashboardLoaded extends DashboardState {
  final DashboardData data;

  const DashboardLoaded(this.data);
}

class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState(this.message);
}

