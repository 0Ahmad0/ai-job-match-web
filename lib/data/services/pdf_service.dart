import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/cv_model.dart';

class PdfService {
  Future<Uint8List> generateCVBytes(
    CvModel data,
    int templateIndex, {
    String languageCode = 'en',
  }) async {
    final pdf = pw.Document();
    final hasArabic = _containsArabicContent(data);
    final isRtl = languageCode.toLowerCase() == 'ar' || hasArabic;
    final labels = _labels(isRtl);

    // Load fonts based on content language
    pw.Font? arabicFont;
    pw.Font? arabicBoldFont;
    pw.Font? arabicItalicFont;

    if (isRtl || hasArabic) {
      // Use Tajawal font for proper Arabic text rendering
      arabicFont = await PdfGoogleFonts.tajawalRegular();
      arabicBoldFont = await PdfGoogleFonts.tajawalBold();
      arabicItalicFont = await PdfGoogleFonts.tajawalMedium();
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: _buildTheme(
          isRtl || hasArabic,
          arabicFont,
          arabicBoldFont,
          arabicItalicFont,
          templateIndex,
        ),
        build: (pw.Context context) {
          final widgets = switch (templateIndex) {
            1 => _buildTemplateModernATS(data, labels: labels, isRtl: isRtl),
            2 => _buildTemplateClassicATS(data, labels: labels, isRtl: isRtl),
            3 => _buildTemplateMinimalistATS(data, labels: labels, isRtl: isRtl),
            _ => _buildTemplateModernATS(data, labels: labels, isRtl: isRtl),
          };
          return widgets;
        },
      ),
    );

    return pdf.save();
  }

  Future<void> generateAndOpenCV(
    CvModel data,
    int templateIndex, {
    String languageCode = 'en',
    String fileName = 'My_Professional_CV.pdf',
  }) async {
    final bytes = await generateCVBytes(
      data,
      templateIndex,
      languageCode: languageCode,
    );
    await openPdfBytes(bytes, fileName: fileName);
  }

  Future<String> savePdfToDevice(
    Uint8List bytes, {
    String fileName = 'My_Professional_CV.pdf',
  }) async {
    Directory? downloadsDir;
    try {
      downloadsDir = await getDownloadsDirectory();
    } catch (_) {
      downloadsDir = null;
    }
    final fallbackDir = await getTemporaryDirectory();
    final outputDir = downloadsDir ?? fallbackDir;
    final file = File('${outputDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> openPdfBytes(
    Uint8List bytes, {
    String fileName = 'My_Professional_CV.pdf',
  }) async {
    final path = await savePdfToDevice(bytes, fileName: fileName);
    await OpenFile.open(path);
  }

  Future<void> sharePdfBytes(
    Uint8List bytes, {
    String fileName = 'My_Professional_CV.pdf',
  }) async {
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  pw.ThemeData _buildTheme(
    bool hasArabic,
    pw.Font? arabicFont,
    pw.Font? arabicBoldFont,
    pw.Font? arabicItalicFont,
    int templateIndex,
  ) {
    if (hasArabic && arabicFont != null) {
      return pw.ThemeData.withFont(
        base: arabicFont,
        bold: arabicBoldFont ?? arabicFont,
        italic: arabicItalicFont ?? arabicFont,
      );
    }

    final fontBase = templateIndex == 2 ? pw.Font.times() : pw.Font.helvetica();
    final fontBold = templateIndex == 2 ? pw.Font.timesBold() : pw.Font.helveticaBold();
    final fontItalic = templateIndex == 2 ? pw.Font.timesItalic() : pw.Font.helveticaOblique();

    return pw.ThemeData.withFont(
      base: fontBase,
      bold: fontBold,
      italic: fontItalic,
    );
  }

  List<pw.Widget> _buildTemplateModernATS(
    CvModel data, {
    required _PdfLabels labels,
    required bool isRtl,
  }) {
    return [
      pw.Header(
        level: 0,
        child: pw.Column(
          crossAxisAlignment: isRtl ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              isRtl ? data.fullName : data.fullName.toUpperCase(),
              textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            if (data.jobTitle.isNotEmpty)
              pw.Text(
                data.jobTitle,
                textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
            pw.SizedBox(height: 5),
            pw.Wrap(
              spacing: 10,
              alignment: isRtl ? pw.WrapAlignment.end : pw.WrapAlignment.start,
              children: [
                pw.Text(
                  data.email,
                  style: const pw.TextStyle(fontSize: 10),
                  textDirection: _textDirectionFor(data.email),
                ),
                pw.Text('|', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey400)),
                pw.Text(
                  data.phone,
                  style: const pw.TextStyle(fontSize: 10),
                  textDirection: _textDirectionFor(data.phone),
                ),
                if (data.address.isNotEmpty) ...[
                  pw.Text('|', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey400)),
                  pw.Text(
                    data.address,
                    style: const pw.TextStyle(fontSize: 10),
                    textDirection: _textDirectionFor(data.address),
                  ),
                ],
              ],
            ),
            if (data.linkedin.isNotEmpty || data.github.isNotEmpty || data.portfolio.isNotEmpty) ...[
              pw.SizedBox(height: 3),
              pw.Wrap(
                spacing: 10,
                children: [
                  if (data.linkedin.isNotEmpty) _buildLinkText(data.linkedin),
                  if (data.github.isNotEmpty) _buildLinkText(data.github),
                  if (data.portfolio.isNotEmpty) _buildLinkText(data.portfolio),
                ],
              ),
            ],
          ],
        ),
      ),
      pw.SizedBox(height: 15),
      if (data.summary.isNotEmpty) ...[
        _buildSectionTitle(labels.summary, isRtl: isRtl),
        pw.Text(
          data.summary,
          style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.4),
          textDirection: _textDirectionFor(data.summary),
          textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
        ),
        pw.SizedBox(height: 15),
      ],
      if (data.experience.isNotEmpty) ...[
        _buildSectionTitle(labels.experience, isRtl: isRtl),
        ...data.experience.map((e) => _buildExperienceItem(e, isRtl: isRtl)),
        pw.SizedBox(height: 10),
      ],
      if (data.projects.isNotEmpty) ...[
        _buildSectionTitle(labels.projects, isRtl: isRtl),
        ...data.projects.map((p) => _buildProjectItem(p, isRtl: isRtl)),
        pw.SizedBox(height: 10),
      ],
      if (data.education.isNotEmpty) ...[
        _buildSectionTitle(labels.education, isRtl: isRtl),
        ...data.education.map((e) => _buildEducationItem(e, isRtl: isRtl)),
        pw.SizedBox(height: 10),
      ],
      if (data.skills.isNotEmpty) ...[
        _buildSectionTitle(labels.skills, isRtl: isRtl),
        pw.Wrap(
          spacing: 6,
          runSpacing: 6,
          children: data.skills
              .map((s) => _buildSkillChip(s.name, s.level, labels: labels))
              .toList(),
        ),
      ],
    ];
  }

  List<pw.Widget> _buildTemplateClassicATS(
    CvModel data, {
    required _PdfLabels labels,
    required bool isRtl,
  }) {
    return [
      pw.Center(
        child: pw.Text(
          data.fullName,
          textDirection: _textDirectionFor(data.fullName),
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 5),
      pw.Center(
        child: pw.Text(
          '${data.address} • ${data.email} • ${data.phone}',
          textDirection: _textDirectionFor('${data.address}${data.email}${data.phone}'),
          style: const pw.TextStyle(fontSize: 10),
        ),
      ),
      pw.Divider(thickness: 0.5),
      pw.SizedBox(height: 10),
      if (data.summary.isNotEmpty) ...[
        _buildSimpleHeader(labels.summary, isRtl: isRtl),
        pw.Text(
          data.summary,
          style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.2),
          textDirection: _textDirectionFor(data.summary),
          textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
        ),
        pw.SizedBox(height: 10),
      ],
      if (data.experience.isNotEmpty) ...[
        _buildSimpleHeader(labels.experience, isRtl: isRtl),
        ...data.experience.map((e) => _buildExperienceItemClassic(e, isRtl: isRtl)),
        pw.SizedBox(height: 5),
      ],
      if (data.projects.isNotEmpty) ...[
        _buildSimpleHeader(labels.projects, isRtl: isRtl),
        ...data.projects.map((p) => _buildProjectItemClassic(p, isRtl: isRtl)),
        pw.SizedBox(height: 5),
      ],
      if (data.education.isNotEmpty) ...[
        _buildSimpleHeader(labels.education, isRtl: isRtl),
        ...data.education.map((e) => _buildEducationItemClassic(e, isRtl: isRtl)),
        pw.SizedBox(height: 5),
      ],
      if (data.skills.isNotEmpty) ...[
        _buildSimpleHeader(labels.skills, isRtl: isRtl),
        pw.Text(
          data.skills.map((s) => s.name).join(' • '),
          style: const pw.TextStyle(fontSize: 11),
          textDirection: _textDirectionFor(data.skills.map((s) => s.name).join('')),
        ),
      ],
    ];
  }

  List<pw.Widget> _buildTemplateMinimalistATS(
    CvModel data, {
    required _PdfLabels labels,
    required bool isRtl,
  }) {
    return _buildTemplateModernATS(data, labels: labels, isRtl: isRtl);
  }

  pw.Widget _buildSectionTitle(String title, {required bool isRtl}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Text(
        title,
        textDirection: _textDirectionFor(title),
        textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  pw.Widget _buildSimpleHeader(String title, {required bool isRtl}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Text(
        isRtl ? title : title.toUpperCase(),
        textDirection: _textDirectionFor(title),
        textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          decoration: pw.TextDecoration.underline,
        ),
      ),
    );
  }

  pw.Widget _buildLinkText(String url) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(
        url,
        textDirection: _textDirectionFor(url),
        style: const pw.TextStyle(
          fontSize: 10,
          color: PdfColors.blue800,
          decoration: pw.TextDecoration.underline,
        ),
      ),
    );
  }

  pw.Widget _buildExperienceItem(CvExperience e, {required bool isRtl}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: isRtl ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  e.jobTitle,
                  textDirection: _textDirectionFor(e.jobTitle),
                  textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                ),
              ),
              pw.Text(
                '${e.startDate} - ${e.endDate}',
                textDirection: _textDirectionFor('${e.startDate}${e.endDate}'),
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.Text(
            e.company,
            textDirection: _textDirectionFor(e.company),
            textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
            style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            e.description,
            textDirection: _textDirectionFor(e.description),
            textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildExperienceItemClassic(CvExperience e, {required bool isRtl}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: isRtl ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                isRtl ? e.company : e.company.toUpperCase(),
                textDirection: _textDirectionFor(e.company),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              ),
              pw.Text(
                '${e.startDate} - ${e.endDate}',
                textDirection: _textDirectionFor('${e.startDate}${e.endDate}'),
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
          pw.Text(
            e.jobTitle,
            textDirection: _textDirectionFor(e.jobTitle),
            textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontStyle: pw.FontStyle.italic,
              fontSize: 11,
            ),
          ),
          pw.Text(
            e.description,
            textDirection: _textDirectionFor(e.description),
            textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildProjectItem(CvProject p, {required bool isRtl}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: isRtl ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                p.name,
                textDirection: _textDirectionFor(p.name),
                textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              ),
              pw.Text(
                p.year,
                textDirection: _textDirectionFor(p.year),
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
          pw.Text(
            p.description,
            textDirection: _textDirectionFor(p.description),
            textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
            style: const pw.TextStyle(fontSize: 10),
          ),
          if (p.url.isNotEmpty) _buildLinkText(p.url),
        ],
      ),
    );
  }

  pw.Widget _buildProjectItemClassic(CvProject p, {required bool isRtl}) =>
      _buildProjectItem(p, isRtl: isRtl);

  pw.Widget _buildEducationItem(CvEducation e, {required bool isRtl}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: isRtl ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              e.school,
              textDirection: _textDirectionFor(e.school),
              textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            pw.Text(
              e.degree,
              textDirection: _textDirectionFor(e.degree),
              textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.Text(
          e.year,
          textDirection: _textDirectionFor(e.year),
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  pw.Widget _buildEducationItemClassic(CvEducation e, {required bool isRtl}) =>
      _buildEducationItem(e, isRtl: isRtl);

  pw.Widget _buildSkillChip(
    String name,
    int level, {
    required _PdfLabels labels,
  }) {
    final levels = labels.levels;
    final safeIndex = (level.clamp(1, 5) as int) - 1;
    final levelText = levels[safeIndex];

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        '$name ($levelText)',
        style: const pw.TextStyle(fontSize: 9),
        textDirection: _textDirectionFor(name),
      ),
    );
  }

  _PdfLabels _labels(bool isArabic) {
    if (isArabic) {
      return const _PdfLabels(
        summary: 'الملخص المهني',
        experience: 'الخبرات',
        projects: 'المشاريع',
        education: 'التعليم',
        skills: 'المهارات',
        levels: ['مبتدئ', 'مستوى أساسي', 'متوسط', 'متقدم', 'خبير'],
      );
    }
    return const _PdfLabels(
      summary: 'PROFESSIONAL SUMMARY',
      experience: 'EXPERIENCE',
      projects: 'PROJECTS',
      education: 'EDUCATION',
      skills: 'SKILLS',
      levels: ['Basic', 'Novice', 'Intermediate', 'Advanced', 'Expert'],
    );
  }

  pw.TextDirection _textDirectionFor(String text) {
    return _isArabicText(text) ? pw.TextDirection.rtl : pw.TextDirection.ltr;
  }

  bool _isArabicText(String value) {
    return RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    ).hasMatch(value);
  }

  bool _containsArabicContent(CvModel data) {
    final buffer = StringBuffer()
      ..write(data.fullName)
      ..write(data.jobTitle)
      ..write(data.summary)
      ..write(data.email)
      ..write(data.phone)
      ..write(data.address)
      ..write(data.linkedin)
      ..write(data.github)
      ..write(data.portfolio);

    for (final item in data.experience) {
      buffer
        ..write(item.jobTitle)
        ..write(item.company)
        ..write(item.startDate)
        ..write(item.endDate)
        ..write(item.description);
    }
    for (final item in data.education) {
      buffer
        ..write(item.school)
        ..write(item.degree)
        ..write(item.year);
    }
    for (final item in data.projects) {
      buffer
        ..write(item.name)
        ..write(item.description)
        ..write(item.year)
        ..write(item.url);
    }
    for (final item in data.skills) {
      buffer.write(item.name);
    }

    return _isArabicText(buffer.toString());
  }
}

class _PdfLabels {
  final String summary;
  final String experience;
  final String projects;
  final String education;
  final String skills;
  final List<String> levels;

  const _PdfLabels({
    required this.summary,
    required this.experience,
    required this.projects,
    required this.education,
    required this.skills,
    required this.levels,
  });
}
