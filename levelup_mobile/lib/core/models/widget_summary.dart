class WidgetSummary {
  final int todayXp;
  final int level;
  final int weekPoints;
  final int pendingReviewsCount;
  final String? nextActionTitle;
  final String lastUpdated;

  WidgetSummary({
    required this.todayXp,
    required this.level,
    required this.weekPoints,
    required this.pendingReviewsCount,
    required this.lastUpdated,
    this.nextActionTitle,
  });

  factory WidgetSummary.fromJson(Map<String, dynamic> json) {
    return WidgetSummary(
      todayXp: (json['today_xp'] ?? 0) as int,
      level: (json['level'] ?? 1) as int,
      weekPoints: (json['week_points'] ?? 0) as int,
      pendingReviewsCount: (json['pending_reviews_count'] ?? 0) as int,
      nextActionTitle: (json['next_action'] is Map)
          ? (json['next_action']['title'] as String?)
          : null,
      lastUpdated: (json['last_updated'] ?? '') as String,
    );
  }
}