class CandidateModel {
  final String id;
  final String name;
  final String jobTitle;
  final int matchScore; // النسبة المئوية
  final List<String> matchingSkills; // المهارات المتطابقة
  final String imageUrl; // صورة وهمية

  CandidateModel({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.matchScore,
    required this.matchingSkills,
    this.imageUrl = '',
  });
}