/// Matcher Utility for calculating job match percentage
class MatcherUtil {
  /// Calculate match percentage between required skills and user skills
  ///
  /// [requiredSkills] - List of skills required by the job
  /// [userSkills] - List of skills the user possesses
  ///
  /// Returns a percentage (0.0 to 100.0) representing how many of the
  /// required skills the user possesses.
  ///
  /// The comparison is case-insensitive and trims whitespace.
  static double calculateMatchPercentage({
    required List<String> requiredSkills,
    required List<String> userSkills,
  }) {
    // Handle edge cases
    if (requiredSkills.isEmpty) {
      return 0.0;
    }

    if (userSkills.isEmpty) {
      return 0.0;
    }

    // Normalize skills: trim whitespace and convert to lowercase
    final normalizedRequired = requiredSkills
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toSet();

    final normalizedUser = userSkills
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toSet();

    // Find intersection (skills that match)
    final matchedSkills = normalizedRequired.intersection(normalizedUser);

    // Calculate percentage
    final percentage = (matchedSkills.length / normalizedRequired.length) * 100.0;

    // Clamp between 0.0 and 100.0
    return percentage.clamp(0.0, 100.0);
  }

  /// Get list of matched skills
  ///
  /// Returns the skills that match between required and user skills
  static List<String> getMatchedSkills({
    required List<String> requiredSkills,
    required List<String> userSkills,
  }) {
    if (requiredSkills.isEmpty || userSkills.isEmpty) {
      return [];
    }

    final normalizedRequired = requiredSkills
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toSet();

    final normalizedUser = userSkills
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toSet();

    final matchedSkills = normalizedRequired.intersection(normalizedUser);

    // Return original casing from required skills
    return requiredSkills
        .where((skill) => normalizedRequired.contains(skill.trim().toLowerCase()))
        .where((skill) => matchedSkills.contains(skill.trim().toLowerCase()))
        .toList();
  }

  /// Get list of missing skills
  ///
  /// Returns the required skills that the user does NOT have
  static List<String> getMissingSkills({
    required List<String> requiredSkills,
    required List<String> userSkills,
  }) {
    if (requiredSkills.isEmpty) {
      return [];
    }

    if (userSkills.isEmpty) {
      return requiredSkills;
    }

    final normalizedRequired = requiredSkills
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toSet();

    final normalizedUser = userSkills
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toSet();

    final missingSkills = normalizedRequired.difference(normalizedUser);

    // Return original casing from required skills
    return requiredSkills
        .where((skill) => missingSkills.contains(skill.trim().toLowerCase()))
        .toList();
  }
}
