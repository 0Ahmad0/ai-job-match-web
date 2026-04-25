/// Matcher Utility for calculating job match percentage.
class MatcherUtil {
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
  };

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
    final normalizedRequired = _normalizeSkillSet(requiredSkills);
    final normalizedUser = _normalizeSkillSet(userSkills);
    if (normalizedRequired.isEmpty || normalizedUser.isEmpty) {
      return 0;
    }

    final matchedSkills = normalizedRequired.intersection(normalizedUser);
    final skillCoverage = matchedSkills.length / normalizedRequired.length;

    final titleOverlap = _jaccardTokens(jobTitle, userTargetTitle);
    final reqOverlap = _requirementOverlap(
      jobRequirements: jobRequirements,
      userKeywords: userProfileKeywords,
      userSkills: normalizedUser,
    );

    // Weighted score:
    // - 70% direct skills coverage
    // - 20% title alignment
    // - 10% requirement text overlap
    final weighted = (skillCoverage * 0.70) + (titleOverlap * 0.20) + (reqOverlap * 0.10);
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
    }
    return normalized;
  }

  static String? _canonicalizeSkill(String raw) {
    final value = raw.trim().toLowerCase();
    if (value.isEmpty) {
      return null;
    }
    final compact = value.replaceAll(RegExp(r'[_\s]+'), ' ');
    final canonical = _skillAliasToCanonical[compact] ?? compact;
    if (canonical.length < 2) {
      return null;
    }
    return canonical;
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
