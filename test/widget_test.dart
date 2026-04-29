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
}
