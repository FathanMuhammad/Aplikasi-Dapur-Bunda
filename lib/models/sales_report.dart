class SalesReport {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final ReportPeriod period;
  final int totalOrders;
  final double totalRevenue;
  final double totalTax;
  final Map<String, int> productSales; // productId -> quantity sold
  final Map<String, double> categoryRevenue; // category -> revenue
  final Map<String, int> paymentMethodCount; // payment method -> count
  final List<DailySales> dailySales;
  final DateTime generatedAt;

  SalesReport({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalTax,
    required this.productSales,
    required this.categoryRevenue,
    required this.paymentMethodCount,
    required this.dailySales,
    required this.generatedAt,
  });

  factory SalesReport.fromMap(Map<String, dynamic> map) {
    return SalesReport(
      id: map['id'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      period: ReportPeriod.values.firstWhere(
        (e) => e.toString() == 'ReportPeriod.${map['period']}',
        orElse: () => ReportPeriod.daily,
      ),
      totalOrders: map['totalOrders'] ?? 0,
      totalRevenue: (map['totalRevenue'] ?? 0).toDouble(),
      totalTax: (map['totalTax'] ?? 0).toDouble(),
      productSales: Map<String, int>.from(map['productSales'] ?? {}),
      categoryRevenue: Map<String, double>.from(map['categoryRevenue'] ?? {}),
      paymentMethodCount: Map<String, int>.from(map['paymentMethodCount'] ?? {}),
      dailySales: (map['dailySales'] as List<dynamic>?)
              ?.map((item) => DailySales.fromMap(item))
              .toList() ??
          [],
      generatedAt: DateTime.parse(map['generatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'period': period.toString().split('.').last,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'totalTax': totalTax,
      'productSales': productSales,
      'categoryRevenue': categoryRevenue,
      'paymentMethodCount': paymentMethodCount,
      'dailySales': dailySales.map((item) => item.toMap()).toList(),
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  double get averageOrderValue {
    return totalOrders > 0 ? totalRevenue / totalOrders : 0;
  }

  String get bestSellingProduct {
    if (productSales.isEmpty) return '';
    return productSales.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String get topCategory {
    if (categoryRevenue.isEmpty) return '';
    return categoryRevenue.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

class DailySales {
  final DateTime date;
  final int orders;
  final double revenue;
  final double tax;

  DailySales({
    required this.date,
    required this.orders,
    required this.revenue,
    required this.tax,
  });

  factory DailySales.fromMap(Map<String, dynamic> map) {
    return DailySales(
      date: DateTime.parse(map['date']),
      orders: map['orders'] ?? 0,
      revenue: (map['revenue'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'orders': orders,
      'revenue': revenue,
      'tax': tax,
    };
  }
}

enum ReportPeriod {
  daily,
  weekly,
  monthly,
  yearly,
  custom,
}

extension ReportPeriodExtension on ReportPeriod {
  String get displayName {
    switch (this) {
      case ReportPeriod.daily:
        return 'Harian';
      case ReportPeriod.weekly:
        return 'Mingguan';
      case ReportPeriod.monthly:
        return 'Bulanan';
      case ReportPeriod.yearly:
        return 'Tahunan';
      case ReportPeriod.custom:
        return 'Kustom';
    }
  }
}

class ReportSummary {
  final double todayRevenue;
  final double weekRevenue;
  final double monthRevenue;
  final int todayOrders;
  final int weekOrders;
  final int monthOrders;
  final List<String> topProducts;
  final Map<String, double> categoryPerformance;

  ReportSummary({
    required this.todayRevenue,
    required this.weekRevenue,
    required this.monthRevenue,
    required this.todayOrders,
    required this.weekOrders,
    required this.monthOrders,
    required this.topProducts,
    required this.categoryPerformance,
  });

  factory ReportSummary.fromMap(Map<String, dynamic> map) {
    return ReportSummary(
      todayRevenue: (map['todayRevenue'] ?? 0).toDouble(),
      weekRevenue: (map['weekRevenue'] ?? 0).toDouble(),
      monthRevenue: (map['monthRevenue'] ?? 0).toDouble(),
      todayOrders: map['todayOrders'] ?? 0,
      weekOrders: map['weekOrders'] ?? 0,
      monthOrders: map['monthOrders'] ?? 0,
      topProducts: List<String>.from(map['topProducts'] ?? []),
      categoryPerformance: Map<String, double>.from(map['categoryPerformance'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todayRevenue': todayRevenue,
      'weekRevenue': weekRevenue,
      'monthRevenue': monthRevenue,
      'todayOrders': todayOrders,
      'weekOrders': weekOrders,
      'monthOrders': monthOrders,
      'topProducts': topProducts,
      'categoryPerformance': categoryPerformance,
    };
  }
}
