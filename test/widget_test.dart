import 'package:ai_job_matcher/core/utils/matcher_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MatcherUtil returns a positive score for overlapping skills', () {
    final score = MatcherUtil.calculateEnhancedMatchPercentage(
      requiredSkills: const ['Flutter', 'Firebase', 'REST API'],
      userSkills: const ['Dart', 'Flutter', 'Firebase'],
      jobRequirements: const ['Build mobile apps with Firebase'],
      userProfileKeywords: const ['Flutter developer with Firebase experience'],
      jobTitle: 'Flutter Developer',
      userTargetTitle: 'Mobile Flutter Developer',
    );

    expect(score, greaterThan(0));
    expect(score, lessThanOrEqualTo(100));
  });

  test(
    'MatcherUtil gives a strong score when Flutter is the required skill',
    () {
      final score = MatcherUtil.calculateEnhancedMatchPercentage(
        requiredSkills: const ['Flutter', 'Developer'],
        userSkills: const ['Flutter Developer'],
        jobRequirements: const [],
        userProfileKeywords: const [],
        jobTitle: 'Flutter Developer',
        userTargetTitle: '',
      );

      expect(score, greaterThanOrEqualTo(80));
    },
  );

  test('MatcherUtil extracts known skills without generic job words', () {
    final skills = MatcherUtil.extractKnownSkillsFromText(
      'We need a Flutter developer to build mobile apps with Firebase.',
    );

    expect(skills, containsAll(['flutter', 'firebase']));
    expect(skills, isNot(contains('developer')));
  });
}
