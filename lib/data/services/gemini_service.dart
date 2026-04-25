import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/cv_model.dart';

class GeminiService extends GetxService {
  late GenerativeModel _model;
  bool _initialized = false;

  Future<GeminiService> init() async {
    if (_initialized) {
      return this;
    }

    try {
      if (!dotenv.isInitialized) {
        await dotenv.load(fileName: '.env');
      }

      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('err_missing_gemini_key'.tr);
      }

      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );
      _initialized = true;
      return this;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to initialize GeminiService: $e',
        name: 'GeminiService',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> analyzeCV(String cvText) async {
    if (cvText.trim().isEmpty) {
      return null;
    }

    await init();
    final prompt = _basePrompt(cvText);
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return _parseResponse(response.text);
    } catch (e, stackTrace) {
      developer.log(
        'Error analyzing CV text: $e',
        name: 'GeminiService',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> analyzeCvModel(CvModel cv) async {
    await init();
    final cvText = _convertModelToText(cv);
    return analyzeCV(cvText);
  }

  String _convertModelToText(CvModel cv) {
    final buffer = StringBuffer();
    buffer.writeln('Full Name: ${cv.fullName}');
    buffer.writeln('Job Title: ${cv.jobTitle}');
    buffer.writeln('Summary: ${cv.summary}');

    buffer.writeln('\nExperience:');
    for (final exp in cv.experience) {
      buffer.writeln('- ${exp.jobTitle} at ${exp.company} (${exp.startDate} - ${exp.endDate})');
      buffer.writeln('  Description: ${exp.description}');
    }

    buffer.writeln('\nEducation:');
    for (final edu in cv.education) {
      buffer.writeln('- ${cv.education.indexOf(edu) + 1}. ${edu.degree} from ${edu.school} (${edu.year})');
    }

    buffer.writeln('\nSkills:');
    for (final skill in cv.skills) {
      buffer.writeln('- ${skill.name} (Level: ${skill.level}/5)');
    }

    buffer.writeln('\nProjects:');
    for (final project in cv.projects) {
      buffer.writeln('- ${project.name} (${project.year})');
      buffer.writeln('  Description: ${project.description}');
    }

    return buffer.toString();
  }

  Future<Map<String, dynamic>?> analyzeCvDocument({
    required Uint8List fileBytes,
    required String mimeType,
    required String fileName,
  }) async {
    if (fileBytes.isEmpty) {
      return null;
    }

    await init();
    final sampleBase64 = base64Encode(
      fileBytes.length > 12000 ? fileBytes.sublist(0, 12000) : fileBytes,
    );
    final prompt = _basePrompt(
      'File Name: $fileName\n'
      'Mime Type: $mimeType\n'
      'Document bytes sample (base64): $sampleBase64',
    );

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return _parseResponse(response.text);
    } catch (e, stackTrace) {
      developer.log(
        'Error analyzing CV document: $e',
        name: 'GeminiService',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      return null;
    }
  }

  Future<String> askPlatformAssistant(
    String userQuestion, {
    required String preferredLanguageCode,
  }) async {
    final question = userQuestion.trim();
    if (question.isEmpty) {
      return '';
    }

    await init();
    final lang = preferredLanguageCode.toLowerCase() == 'ar' ? 'ar' : 'en';
    final systemPrompt = '''
You are a helpful assistant for the AI Job Matcher platform.
Your job is to answer users about:
1) How to use platform features (CV builder, AI analyzer, applying to jobs, tracking applications).
2) Job-search and hiring tips.

Rules:
- Be concise and practical.
- If asked unrelated dangerous/illegal content, refuse politely.
- The final answer language MUST be: $lang.
''';

    final prompt = '$systemPrompt\n\nUser question:\n$question';
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return (response.text ?? '').trim();
    } catch (e, stackTrace) {
      developer.log(
        'Error in platform assistant chat: $e',
        name: 'GeminiService',
        error: e,
        stackTrace: stackTrace,
      );
      return '';
    }
  }

  Future<Map<String, dynamic>?> generateJobDraft({
    required String jobTitle,
    required String jobType,
    required String location,
    required List<String> preferredSkills,
    required String languageCode,
  }) async {
    final title = jobTitle.trim();
    if (title.isEmpty) {
      return null;
    }

    await init();
    final lang = languageCode.toLowerCase() == 'ar' ? 'ar' : 'en';
    final skills = preferredSkills
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final seedSkills = skills.isEmpty ? 'none' : skills.join(', ');

    final prompt = '''
You are a senior technical recruiter.
Generate a realistic job draft based on the given role and skills.

Inputs:
- job_title: "$title"
- job_type: "$jobType"
- location: "$location"
- preferred_skills: "$seedSkills"
- output_language: "$lang"

Return STRICT JSON only with this shape:
{
  "description": "string",
  "required_skills": ["skill 1", "skill 2"],
  "requirements": ["requirement 1", "requirement 2"]
}

Rules:
- description must be practical and not generic filler.
- required_skills should contain 8 to 14 focused skills used globally for this role.
- requirements should contain 6 to 10 concise, measurable requirements.
- Keep consistency between description, required_skills, and requirements.
- If preferred_skills are provided, include the relevant ones.
- Return valid JSON only.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final parsed = _parseJsonObject(response.text);
      if (parsed == null) {
        return _fallbackJobDraft(
          title: title,
          skills: skills,
          lang: lang,
        );
      }
      return parsed;
    } catch (e, stackTrace) {
      developer.log(
        'Error generating AI job draft: $e',
        name: 'GeminiService',
        error: e,
        stackTrace: stackTrace,
      );
      return _fallbackJobDraft(
        title: title,
        skills: skills,
        lang: lang,
      );
    }
  }

  String _basePrompt(String input) {
    return '''
You are an expert ATS (Applicant Tracking System) with 20+ years of experience in recruitment and HR.

Analyze the provided CV and extract the following information in a STRICT JSON format:
1. job_title: The primary detected job title/profession
2. skills: A list of key professional skills detected (minimum 3, maximum 10)
3. ats_score: An ATS compatibility score from 0-100 (integer only)
4. suggestions_for_improvement: Specific actionable suggestions to improve the CV (minimum 2, maximum 5)
5. cv_language: The dominant language of the CV content. Return "ar" for Arabic or "en" for English.

INPUT:
$input

IMPORTANT INSTRUCTIONS:
- Return ONLY a valid JSON string
- Do NOT include markdown formatting
- Do NOT include explanatory text
- Return this exact shape:
{
  "job_title": "Primary detected job title",
  "skills": ["skill 1", "skill 2", "skill 3"],
  "ats_score": 85,
  "suggestions_for_improvement": ["suggestion 1", "suggestion 2"],
  "cv_language": "en"
}

The suggestions_for_improvement MUST be written in the same language as cv_language.
''';
  }

  Map<String, dynamic>? _parseResponse(String? responseText) {
    if (responseText == null || responseText.trim().isEmpty) {
      return null;
    }

    try {
      var cleanedText = responseText.trim();
      if (cleanedText.startsWith('```json')) {
        cleanedText = cleanedText.substring(7);
      }
      if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.substring(3);
      }
      if (cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(0, cleanedText.length - 3);
      }
      cleanedText = cleanedText.trim();

      final result = jsonDecode(cleanedText) as Map<String, dynamic>;
      if (!result.containsKey('job_title') ||
          !result.containsKey('skills') ||
          !result.containsKey('ats_score') ||
          !result.containsKey('suggestions_for_improvement')) {
        return null;
      }
      return result;
    } catch (e) {
      developer.log(
        'Failed parsing Gemini response: $e',
        name: 'GeminiService',
        level: 900,
      );
      return null;
    }
  }

  Map<String, dynamic>? _parseJsonObject(String? responseText) {
    if (responseText == null || responseText.trim().isEmpty) {
      return null;
    }

    try {
      var cleanedText = responseText.trim();
      if (cleanedText.startsWith('```json')) {
        cleanedText = cleanedText.substring(7);
      }
      if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.substring(3);
      }
      if (cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(0, cleanedText.length - 3);
      }
      cleanedText = cleanedText.trim();
      final parsed = jsonDecode(cleanedText);
      if (parsed is Map<String, dynamic>) {
        return parsed;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _fallbackJobDraft({
    required String title,
    required List<String> skills,
    required String lang,
  }) {
    final defaults = <String>[
      'Communication',
      'Problem Solving',
      'Team Collaboration',
      'Time Management',
      'Documentation',
    ];
    final mergedSkills = <String>{...skills, ...defaults}.toList().take(10).toList();

    if (lang == 'ar') {
      return {
        'description':
            'نبحث عن $title يمتلك خبرة عملية وقدرة على تنفيذ المهام بكفاءة ضمن فريق متعاون، مع الالتزام بجودة التنفيذ والتحسين المستمر.',
        'required_skills': mergedSkills,
        'requirements': [
          'خبرة عملية مناسبة في نفس المجال.',
          'إتقان المهارات الأساسية المطلوبة للوظيفة.',
          'قدرة عالية على حل المشكلات واتخاذ القرار.',
          'مهارات تواصل فعالة والعمل ضمن فريق.',
          'الالتزام بالمواعيد وجودة التسليم.',
          'قابلية التعلم والتطور المستمر.',
        ],
      };
    }

    return {
      'description':
          'We are hiring a $title who can deliver high-quality outcomes, collaborate effectively with cross-functional teams, and continuously improve execution.',
      'required_skills': mergedSkills,
      'requirements': [
        'Hands-on experience in a similar role.',
        'Strong command of core technical and functional skills.',
        'Solid problem-solving and decision-making ability.',
        'Clear communication and team collaboration skills.',
        'Consistent ownership of quality and deadlines.',
        'Continuous learning mindset and adaptability.',
      ],
    };
  }
}


