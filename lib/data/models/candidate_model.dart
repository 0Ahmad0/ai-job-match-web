class CandidateModel {
  final String id;
  final String name;
  final String jobTitle;
  final int matchScore;
  final List<String> matchingSkills;
  final String imageUrl;
  final String status;

  CandidateModel({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.matchScore,
    required this.matchingSkills,
    this.imageUrl = '',
    this.status = 'pending',
  });

  CandidateModel copyWith({
    String? id,
    String? name,
    String? jobTitle,
    int? matchScore,
    List<String>? matchingSkills,
    String? imageUrl,
    String? status,
  }) {
    return CandidateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      matchScore: matchScore ?? this.matchScore,
      matchingSkills: matchingSkills ?? this.matchingSkills,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }
}
