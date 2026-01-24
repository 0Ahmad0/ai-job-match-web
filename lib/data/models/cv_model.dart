class CvModel {
  // Personal Info
  String fullName = '';
  String email = '';
  String phone = '';
  String address = '';
  String linkedin = '';
  String portfolio = '';
  String github = '';
  String jobTitle = ''; // المسمى الوظيفي تحت الاسم

  // Summary
  String summary = '';

  // Experience (مع تعديل التواريخ)
  List<CvExperience> experience = [];

  // Education
  List<CvEducation> education = [];

  // Skills
  List<CvSkill> skills = [];

  // Languages
  List<CvLanguage> languages = [];

  // Certifications
  List<CvCertification> certifications = [];

  // Projects (جديد)
  List<CvProject> projects = [];
}

class CvExperience {
  String jobTitle;
  String company;
  String startDate;
  String endDate; // إذا كانت "Present" يعني ما زلت تعمل هنا
  String description;
  int experienceLevel; // من 1 إلى 5

  CvExperience({
    this.jobTitle = '',
    this.company = '',
    this.startDate = '',
    this.endDate = 'Present', // افتراضي: ما زلت أعمل هنا
    this.description = '',
    this.experienceLevel = 1,
  });
}

class CvProject {
  // ✅ جديد: المشاريع
  String name;
  String description;
  String year;
  String url; // رابط المشروع

  CvProject({
    this.name = '',
    this.description = '',
    this.year = '',
    this.url = '',
  });
}

class CvEducation {
  String degree;
  String school;
  String year;
  double gpa; // المعدل التراكمي

  CvEducation({
    this.degree = '',
    this.school = '',
    this.year = '',
    this.gpa = 0.0,
  });
}

class CvSkill {
  String name;
  int level; // من 1 إلى 5

  CvSkill({this.name = '', this.level = 1});
}

class CvLanguage {
  String name;
  String level; // مبتدئ، متوسط، متقدم، طليق

  CvLanguage({this.name = '', this.level = 'مبتدئ'});
}

class CvCertification {
  String name;
  String issuer;
  String year;
  String url; // رابط الشهادة

  CvCertification({
    this.name = '',
    this.issuer = '',
    this.year = '',
    this.url = '',
  });
}
