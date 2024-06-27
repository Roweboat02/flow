import 'package:flow/post.dart';
import 'package:flow/post_sorting/filter_aspect.dart';
import 'dart:math' as math;

class DistanceAspect implements FilterAspect {
  static num r = 6371;
  static num findDistance(num lat0, num long0, num lat1, num long1) {
    return 2 *
        r *
        math.asin(math.sqrt((1 -
                math.cos(lat1 - lat0) +
                math.cos(lat0) *
                    math.cos(lat1) *
                    (1 - math.cos(long1 - long0))) /
            2));
  }

  static List<num> findDistances(
      num lat, num long, List<num> lats, List<num> longs) {
    List<num> temp = [];
    for (var i = 0; i < lats.length; i++) {
      temp.add(findDistance(lat, long, lats[i], longs[i]));
    }
    return temp;
  }

  @override
  List<Post> applyFilter(List<Post> posts) {
    // TODO: implement applyFilter
    throw UnimplementedError();
  }
}
