/// Matcher Utility for calculating job match percentage.
class MatcherUtil {
  static const List<String> _knownSkillTerms = [
    'flutter',
    'dart',
    'firebase',
    'javascript',
    'typescript',
    'react',
    'react.js',
    'reactjs',
    'vue',
    'vue.js',
    'angular',
    'node',
    'nodejs',
    'node.js',
    'python',
    'java',
    'kotlin',
    'swift',
    'php',
    'laravel',
    'sql',
    'mysql',
    'postgres',
    'postgresql',
    'mongodb',
    'mongo',
    'html',
    'css',
    'figma',
    'ui/ux',
    'git',
    'docker',
    'kubernetes',
    'k8s',
    'aws',
    'api',
    'rest',
    'rest api',
    'graphql',
    'machine learning',
    'ml',
    'ai',
    'nlp',
    'c#',
    'c sharp',
    'csharp',
    '.net',
    'dotnet',
    'asp.net',
    'next',
    'next.js',
    'nextjs',
    'nuxt',
    'nuxt.js',
    'nuxtjs',
  ];

  static const Map<String, String> _skillAliasToCanonical = {
    'js': 'javascript',
    'node': 'nodejs',
    'node.js': 'nodejs',
    'ts': 'typescript',
    'c sharp': 'c#',
    'csharp': 'c#',
    'dotnet': '.net',
    'asp.net': '.net',
    'react.js': 'react',
    'reactjs': 'react',
    'vue.js': 'vue',
    'vuejs': 'vue',
    'next.js': 'nextjs',
    'next': 'nextjs',
    'nuxt.js': 'nuxtjs',
    'nuxt': 'nuxtjs',
    'postgres': 'postgresql',
    'mongo': 'mongodb',
    'k8s': 'kubernetes',
    'ml': 'machine learning',
    'ai': 'artificial intelligence',
    'nlp': 'natural language processing',
    'oop': 'object oriented programming',
    'ui ux': 'ui/ux',
    'rest api': 'rest',
  };

  static const Set<String> _nonSkillTerms = {
    'developer',
    'engineer',
    'programmer',
    'designer',
    'specialist',
    'manager',
    'senior',
    'junior',
    'mid',
    'middle',
    'lead',
    'mobile',
    'web',
    'full',
    'time',
    'part',
    'remote',
    'contract',
    'job',
    'role',
    'position',
    'required',
    'requirements',
    'experience',
    'years',
    'year',
    'skills',
    'skill',
    'knowledge',
    'strong',
    'good',
    'with',
    'and',
    'or',
    'the',
    'for',
    'to',
    'in',
    'of',
    'on',
    'by',
    'from',
    'using',
    'use',
    'build',
    'builds',
    'building',
    'develop',
    'developing',
    'development',
    'create',
    'creating',
    'app',
    'apps',
    'application',
    'applications',
    'software',
    'candidate',
    'candidates',
    'must',
    'should',
    'able',
    'ability',
    'work',
    'team',
    'clean',
    'architecture',
    'state',
    'management',
  };

  static List<String> extractKnownSkillsFromText(String text) {
    final normalized = _normalizeText(text);
    final found = <String>{};

    for (final term in _knownSkillTerms) {
      final canonical = _canonicalizeSkill(term);
      if (canonical == null) {
        continue;
      }
      final escaped = RegExp.escape(term.toLowerCase());
      final pattern = RegExp(
        r'(^|[^a-z0-9+#/])' + escaped + r'($|[^a-z0-9+#/])',
      );
      if (pattern.hasMatch(normalized)) {
        found.add(canonical);
      }
    }

    return found.toList();
  }

  static double calculateMatchPercentage({
    required List<String> requiredSkills,
    required List<String> userSkills,
  }) {
    final score = calculateEnhancedMatchPercentage(
      requiredSkills: requiredSkills,
      userSkills: userSkills,
      jobRequirements: const [],
      userProfileKeywords: const [],
      jobTitle: '',
      userTargetTitle: '',
    );
    return score.toDouble();
  }

  static int calculateEnhancedMatchPercentage({
    required List<String> requiredSkills,
    required List<String> userSkills,
    required List<String> jobRequirements,
    required List<String> userProfileKeywords,
    required String jobTitle,
    required String userTargetTitle,
  }) {
    final normalizedRequired = _normalizeSkillSet([
      ...requiredSkills,
      ...extractKnownSkillsFromText(jobTitle),
      ...extractKnownSkillsFromText(jobRequirements.join(' ')),
    ]);
    final normalizedUser = _normalizeSkillSet([
      ...userSkills,
      ...extractKnownSkillsFromText(userTargetTitle),
      ...extractKnownSkillsFromText(userProfileKeywords.join(' ')),
    ]);
    if (normalizedUser.isEmpty) {
      return 0;
    }

    final matchedSkills = normalizedRequired.intersection(normalizedUser);
    final skillCoverage = normalizedRequired.isEmpty
        ? 0.0
        : matchedSkills.length / normalizedRequired.length;

    final titleSkills = _normalizeSkillSet(
      extractKnownSkillsFromText(jobTitle),
    );
    final titleSkillCoverage = titleSkills.isEmpty
        ? 0.0
        : titleSkills.intersection(normalizedUser).length / titleSkills.length;
    final titleOverlap = _jaccardTokens(jobTitle, userTargetTitle);
    final titleAlignment = titleSkillCoverage > titleOverlap
        ? titleSkillCoverage
        : titleOverlap;
    final reqOverlap = _requirementOverlap(
      jobRequirements: jobRequirements,
      userKeywords: userProfileKeywords,
      userSkills: normalizedUser,
    );

    final weighted = normalizedRequired.isEmpty
        ? (titleAlignment * 0.80) + (reqOverlap * 0.20)
        : (skillCoverage * 0.75) +
              (titleAlignment * 0.15) +
              (reqOverlap * 0.10);
    return (weighted * 100).round().clamp(0, 100);
  }

  static List<String> getMatchedSkills({
    required List<String> requiredSkills,
    required List<String> userSkills,
  }) {
    if (requiredSkills.isEmpty || userSkills.isEmpty) {
      return [];
    }
    final normalizedUser = _normalizeSkillSet(userSkills);
    return requiredSkills.where((skill) {
      final canonical = _canonicalizeSkill(skill);
      return canonical != null && normalizedUser.contains(canonical);
    }).toList();
  }

  static List<String> getMissingSkills({
    required List<String> requiredSkills,
    required List<String> userSkills,
  }) {
    if (requiredSkills.isEmpty) {
      return [];
    }
    final normalizedUser = _normalizeSkillSet(userSkills);
    return requiredSkills.where((skill) {
      final canonical = _canonicalizeSkill(skill);
      return canonical == null || !normalizedUser.contains(canonical);
    }).toList();
  }

  static Set<String> _normalizeSkillSet(List<String> skills) {
    final normalized = <String>{};
    for (final skill in skills) {
      final canonical = _canonicalizeSkill(skill);
      if (canonical != null) {
        normalized.add(canonical);
      }
      normalized.addAll(extractKnownSkillsFromText(skill));
    }
    return normalized;
  }

  static String? _canonicalizeSkill(String raw) {
    final value = _normalizeText(raw).trim();
    if (value.isEmpty) {
      return null;
    }
    final compact = value.replaceAll(RegExp(r'[_\s]+'), ' ');
    final canonical = _skillAliasToCanonical[compact] ?? compact;
    if (canonical.length < 2 || _nonSkillTerms.contains(canonical)) {
      return null;
    }
    return canonical;
  }

  static String _normalizeText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[_\s]+'), ' ');
  }

  static double _jaccardTokens(String a, String b) {
    final aTokens = _tokenize(a);
    final bTokens = _tokenize(b);
    if (aTokens.isEmpty || bTokens.isEmpty) {
      return 0;
    }
    final intersection = aTokens.intersection(bTokens).length;
    final union = aTokens.union(bTokens).length;
    if (union == 0) {
      return 0;
    }
    return intersection / union;
  }

  static double _requirementOverlap({
    required List<String> jobRequirements,
    required List<String> userKeywords,
    required Set<String> userSkills,
  }) {
    if (jobRequirements.isEmpty) {
      return 0;
    }
    final requirementTokens = _tokenize(jobRequirements.join(' '));
    if (requirementTokens.isEmpty) {
      return 0;
    }

    final profileTokens = <String>{
      ..._tokenize(userKeywords.join(' ')),
      ...userSkills,
    };
    if (profileTokens.isEmpty) {
      return 0;
    }

    final intersection = requirementTokens.intersection(profileTokens).length;
    return (intersection / requirementTokens.length).clamp(0, 1);
  }

  static Set<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .split(RegExp(r'[^a-z0-9+#./]+'))
        .map((e) => e.trim())
        .where((e) => e.length >= 2)
        .toSet();
  }
}
