import 'package:flow/DatabaseProxy/post_sorting/distance_aspect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("", () {
    expect(
        DistanceAspect.findDistance(51.5007, 0.1246, 40.6892, 74.0445).round(),
        5575);
  });
}
