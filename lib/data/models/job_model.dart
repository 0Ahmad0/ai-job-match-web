class JobModel {
  final String id;
  final String title;
  final String company;
  final String companyId;
  final String location;
  final String logoUrl;
  final String type; // Remote, Full-time
  final String salary;
  final int matchScore;
  final String postedTime;
  final String description;
  final List<String> requiredSkills;

  // ✅ حقول جديدة
  final String experienceYears; // "3-5 Years"
  final String level;           // "Senior", "Mid"
  final List<String> requirements; // قائمة نقاط

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    this.companyId = '',
    required this.location,
    this.logoUrl = '',
    required this.type,
    required this.salary,
    required this.matchScore,
    required this.postedTime,
    required this.description,
    this.requiredSkills = const [],
    this.experienceYears = '2+ Years',
    this.level = 'Mid Level',
    this.requirements = const [
      'Bachelor degree in Computer Science or related field.',
      'Strong knowledge of Dart and Flutter framework.',
      'Experience with RESTful APIs.',
      'Knowledge of clean architecture and state management.',
    ],
  });
}
