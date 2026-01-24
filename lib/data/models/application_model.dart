enum AppStatus { pending, accepted, rejected }

class ApplicationModel {
  final String id;
  final String jobTitle;
  final String company;
  final String logoUrl;
  final String appliedDate;
  final AppStatus status;

  final String? rejectionReason;
  final String? startDate;
  final String? offerSalary;

  ApplicationModel({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.logoUrl,
    required this.appliedDate,
    required this.status,
    this.rejectionReason,
    this.startDate,
    this.offerSalary,
  });
}