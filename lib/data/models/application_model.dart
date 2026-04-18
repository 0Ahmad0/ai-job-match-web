/// Application status enum representing the full workflow.
/// Statuses are mutually exclusive and follow valid transitions:
///   applied -> under_review -> interview_scheduled -> accepted/rejected
///   applied -> under_review -> accepted/rejected
enum AppStatus {
  applied,
  underReview,
  interviewScheduled,
  accepted,
  rejected,
}

class ApplicationModel {
  final String id;
  final String jobTitle;
  final String company;
  final String logoUrl;
  final String appliedDate;
  final AppStatus status;
  final String currentStage;

  // Rejection details
  final String? rejectionReason;

  // Acceptance details
  final String? startDate;
  final String? offerSalary;

  // Interview details
  final String? interviewDate;
  final String? interviewTime;
  final String? interviewNotes;
  final String? interviewLocation;

  final int? matchScore;

  ApplicationModel({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.logoUrl,
    required this.appliedDate,
    required this.status,
    required this.currentStage,
    this.rejectionReason,
    this.startDate,
    this.offerSalary,
    this.interviewDate,
    this.interviewTime,
    this.interviewNotes,
    this.interviewLocation,
    this.matchScore,
  });

  factory ApplicationModel.fromFirestore(String id, Map<String, dynamic> data) {
    final rawStatus = ((data['status'] ?? data['decision']) as String? ?? 'applied').toLowerCase();
    return ApplicationModel(
      id: id,
      jobTitle: (data['job_title'] as String?) ?? '',
      company: (data['company_name'] as String?) ?? (data['company'] as String?) ?? '',
      logoUrl: (data['logo_url'] as String?) ?? '',
      appliedDate: _formatDate(data['created_at']),
      status: _mapStatus(rawStatus),
      currentStage: rawStatus,
      rejectionReason: data['rejection_reason'] as String?,
      startDate: data['start_date'] as String?,
      offerSalary: data['offer_salary'] as String?,
      interviewDate: data['interview_date'] as String?,
      interviewTime: data['interview_time'] as String?,
      interviewNotes: data['interview_notes'] as String?,
      interviewLocation: data['interview_location'] as String?,
      matchScore: (data['match_score'] as num?)?.toInt(),
    );
  }

  static AppStatus _mapStatus(String raw) {
    switch (raw) {
      case 'accepted':
      case 'shortlisted':
        return AppStatus.accepted;
      case 'interview':
      case 'interview_requested':
      case 'interview_scheduled':
        return AppStatus.interviewScheduled;
      case 'rejected':
        return AppStatus.rejected;
      case 'under_review':
      case 'under_review':
        return AppStatus.underReview;
      case 'applied':
      case 'pending':
      default:
        return AppStatus.applied;
    }
  }

  static String _formatDate(dynamic timestamp) {
    if (timestamp == null) {
      return '-';
    }
    try {
      final dateTime = timestamp.toDate() as DateTime;
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');
      return '${dateTime.year}-$month-$day';
    } catch (_) {
      return '-';
    }
  }

  /// Returns true if this application is in a terminal (final) state.
  bool isTerminal() {
    return status == AppStatus.accepted || status == AppStatus.rejected;
  }
}
