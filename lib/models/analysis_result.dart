class AnalysisResult {
  final String label;
  final double riskScore;
  final String cleanMessage;
  final String recommendation;
  final String source;
  final List<String> reasons;

  AnalysisResult({
    required this.label,
    required this.riskScore,
    required this.cleanMessage,
    required this.recommendation,
    required this.source,
    required this.reasons,
  });

  bool get isPhishing {
    return label.toLowerCase() == 'phishing';
  }

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    final dynamic rawReasons = json['reasons'];

    List<String> parsedReasons = [];

    if (rawReasons is List) {
      parsedReasons = rawReasons.map((item) => item.toString()).toList();
    }

    return AnalysisResult(
      label: json['label']?.toString() ?? 'safe',
      riskScore: (json['risk_score'] ?? 0).toDouble(),
      cleanMessage: json['clean_message']?.toString() ?? '',
      recommendation: json['recommendation']?.toString() ?? '',
      source: json['source']?.toString() ?? 'server',
      reasons: parsedReasons,
    );
  }
}
