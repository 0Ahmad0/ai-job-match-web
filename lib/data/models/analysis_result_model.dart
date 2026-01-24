class AnalysisResultModel {
  final int score;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<AnalysisTip> tips;

  AnalysisResultModel({
    required this.score,
    required this.matchedSkills,
    required this.missingSkills,
    required this.tips,
  });
}

class AnalysisTip {
  final String title;
  final String description;
  final bool isCritical;

  AnalysisTip({required this.title, required this.description, this.isCritical = false});
}