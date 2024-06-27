import 'package:flow/database_proxy.dart';
import 'package:flow/post.dart';
import 'package:flow/post_sorting/filter_aspect.dart';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

class DistanceAspect implements FilterAspect {
  static num r = 6371;
  num maxDist = 15;

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
  Future<List<Post>> applyFilter(List<Post> posts) async {
    Position pos = await DatabaseProxy.position;
    List<num> lats = posts.map((Post e) => e.lat).toList();
    List<num> longs = posts.map((Post e) => e.long).toList();
    List<num> distances =
        findDistances(pos.latitude, pos.longitude, lats, longs);
    List<Post> temp = [];
    for (var i = 0; i < distances.length; i++) {
      if (distances[i] < maxDist) {
        temp.add(posts[i]);
      }
    }
    return temp;
  }
}
