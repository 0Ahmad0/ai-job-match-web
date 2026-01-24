import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../models/cv_model.dart';

class PdfService {

  // الدالة الرئيسية
  Future<void> generateAndOpenCV(CvModel data, int templateIndex) async {
    final pdf = pw.Document();

    // 1. إعداد الثيم الموحد
    final pageTheme = await _buildPageTheme(templateIndex);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          switch (templateIndex) {
            case 1: return _buildTemplateModernATS(data);
            case 2: return _buildTemplateClassicATS(data);
            case 3: return _buildTemplateMinimalistATS(data);
            default: return _buildTemplateModernATS(data);
          }
        },
      ),
    );

    // 2. الحفظ والفتح
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/My_Professional_CV.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  // إعداد الخطوط والهوامش
  Future<pw.PageTheme> _buildPageTheme(int templateIndex) async {
    // نستخدم خطوط قياسية لضمان قراءة ATS
    // Classic = Times New Roman (Serif)
    // Others = Helvetica (Sans-Serif)
    final fontBase = templateIndex == 2 ? pw.Font.times() : pw.Font.helvetica();
    final fontBold = templateIndex == 2 ? pw.Font.timesBold() : pw.Font.helveticaBold();
    final fontItalic = templateIndex == 2 ? pw.Font.timesItalic() : pw.Font.helveticaOblique();

    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32), // هوامش قياسية
      theme: pw.ThemeData.withFont(
        base: fontBase,
        bold: fontBold,
        italic: fontItalic,
      ),
    );
  }

  // ===========================================================================
  // ✨ Template 1: Modern ATS (العصري)
  // ===========================================================================
  List<pw.Widget> _buildTemplateModernATS(CvModel data) {
    return [
      // Header
      pw.Header(
        level: 0,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(data.fullName.toUpperCase(), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            if (data.jobTitle.isNotEmpty)
              pw.Text(data.jobTitle, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),

            pw.SizedBox(height: 5),

            // Contact Info Row
            pw.Wrap(
              spacing: 10,
              children: [
                pw.Text(data.email, style: const pw.TextStyle(fontSize: 10)),
                pw.Text("|", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey400)),
                pw.Text(data.phone, style: const pw.TextStyle(fontSize: 10)),
                if (data.address.isNotEmpty) ...[
                  pw.Text("|", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey400)),
                  pw.Text(data.address, style: const pw.TextStyle(fontSize: 10)),
                ]
              ],
            ),

            // Links Row
            if (data.linkedin.isNotEmpty || data.github.isNotEmpty || data.portfolio.isNotEmpty) ...[
              pw.SizedBox(height: 3),
              pw.Wrap(
                  spacing: 10,
                  children: [
                    if (data.linkedin.isNotEmpty) _buildLinkText("LinkedIn", data.linkedin),
                    if (data.github.isNotEmpty) _buildLinkText("GitHub", data.github),
                    if (data.portfolio.isNotEmpty) _buildLinkText("Portfolio", data.portfolio),
                  ]
              )
            ]
          ],
        ),
      ),

      pw.SizedBox(height: 15),

      // Sections
      if (data.summary.isNotEmpty) ...[
        _buildSectionTitle('PROFESSIONAL SUMMARY'),
        pw.Text(data.summary, style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.4)),
        pw.SizedBox(height: 15),
      ],

      if (data.experience.isNotEmpty) ...[
        _buildSectionTitle('EXPERIENCE'),
        ...data.experience.map((e) => _buildExperienceItem(e)),
        pw.SizedBox(height: 10),
      ],

      if (data.projects.isNotEmpty) ...[
        _buildSectionTitle('PROJECTS'),
        ...data.projects.map((p) => _buildProjectItem(p)),
        pw.SizedBox(height: 10),
      ],

      if (data.education.isNotEmpty) ...[
        _buildSectionTitle('EDUCATION'),
        ...data.education.map((e) => _buildEducationItem(e)),
        pw.SizedBox(height: 10),
      ],

      if (data.skills.isNotEmpty) ...[
        _buildSectionTitle('SKILLS'),
        pw.Wrap(
          spacing: 6,
          runSpacing: 6,
          children: data.skills.map((s) => _buildSkillChip(s.name, s.level)).toList(),
        ),
      ],
    ];
  }

  // ===========================================================================
  // 🏛️ Template 2: Classic ATS (الكلاسيكي)
  // ===========================================================================
  List<pw.Widget> _buildTemplateClassicATS(CvModel data) {
    return [
      pw.Center(child: pw.Text(data.fullName, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold))),
      pw.SizedBox(height: 5),
      pw.Center(child: pw.Text("${data.address} • ${data.email} • ${data.phone}", style: const pw.TextStyle(fontSize: 10))),

      pw.Divider(thickness: 0.5),
      pw.SizedBox(height: 10),

      if (data.summary.isNotEmpty) ...[
        _buildSimpleHeader("Professional Summary"),
        pw.Text(data.summary, style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.2)),
        pw.SizedBox(height: 10),
      ],

      if (data.experience.isNotEmpty) ...[
        _buildSimpleHeader("Experience"),
        ...data.experience.map((e) => _buildExperienceItemClassic(e)),
        pw.SizedBox(height: 5),
      ],

      if (data.projects.isNotEmpty) ...[
        _buildSimpleHeader("Projects"),
        ...data.projects.map((p) => _buildProjectItemClassic(p)),
        pw.SizedBox(height: 5),
      ],

      if (data.education.isNotEmpty) ...[
        _buildSimpleHeader("Education"),
        ...data.education.map((e) => _buildEducationItemClassic(e)),
        pw.SizedBox(height: 5),
      ],

      if (data.skills.isNotEmpty) ...[
        _buildSimpleHeader("Skills"),
        pw.Text(data.skills.map((s) => s.name).join(" • "), style: const pw.TextStyle(fontSize: 11)),
      ]
    ];
  }

  // ===========================================================================
  // 🌿 Template 3: Minimalist (النظيف)
  // ===========================================================================
  List<pw.Widget> _buildTemplateMinimalistATS(CvModel data) {
    // نسخة مختصرة من المودرن مع تغييرات طفيفة في التنسيق
    return _buildTemplateModernATS(data);
  }

  // ===========================================================================
  // 🛠️ Helpers & Reusable Widgets (أدوات المساعدة)
  // ===========================================================================

  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400))),
      child: pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  pw.Widget _buildSimpleHeader(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Text(title.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
    );
  }

  pw.Widget _buildLinkText(String label, String url) {
    return pw.UrlLink(
      child: pw.Text(url, style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue800, decoration: pw.TextDecoration.underline)),
      destination: url,
    );
  }

  // --- Experience Items ---
  pw.Widget _buildExperienceItem(dynamic e) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.Text("${e.startDate} - ${e.endDate}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            ],
          ),
          pw.Text(e.company, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11)),
          pw.SizedBox(height: 2),
          pw.Text(e.description, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _buildExperienceItemClassic(dynamic e) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(e.company.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text("${e.startDate} - ${e.endDate}", style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
          pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic, fontSize: 11)),
          pw.Text(e.description, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  // --- Project Items ---
  pw.Widget _buildProjectItem(dynamic p) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(p.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text(p.year, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
          pw.Text(p.description, style: const pw.TextStyle(fontSize: 10)),
          if (p.url.isNotEmpty) _buildLinkText("Link", p.url),
        ],
      ),
    );
  }

  pw.Widget _buildProjectItemClassic(dynamic p) {
    return _buildProjectItem(p); // نفس التصميم تقريباً للكلاسيك
  }

  // --- Education Items ---
  pw.Widget _buildEducationItem(dynamic e) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(e.school, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(e.degree, style: const pw.TextStyle(fontSize: 10)),
        ]),
        pw.Text(e.year, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildEducationItemClassic(dynamic e) {
    return _buildEducationItem(e);
  }

  // --- Skills ---
  pw.Widget _buildSkillChip(String name, int level) {
    // تحويل المستوى لنص
    String levelText = ["Basic", "Novice", "Intermediate", "Advanced", "Expert"][level - 1];
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400), borderRadius: pw.BorderRadius.circular(4)),
      child: pw.Text("$name ($levelText)", style: const pw.TextStyle(fontSize: 9)),
    );
  }
}