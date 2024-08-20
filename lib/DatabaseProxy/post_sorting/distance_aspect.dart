import 'package:flow/DatabaseProxy/database_proxy.dart';
import 'package:flow/Constructs/post.dart';
import 'package:flow/DatabaseProxy/post_sorting/filter_aspect.dart';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

class DistanceAspect implements FilterAspect {
  static num r = 6371;
  static num maxDist = 100;

  static num findDistance(num lat0, num long0, num lat1, num long1) {
    var dLat = (lat1 - lat0) * math.pi / 180.0;
    var dLong = (long1 - long0) * math.pi / 180.0;
    var l1 = lat1 * math.pi / 180.0;
    var l0 = lat0 * math.pi / 180.0;
    var a = math.pow(math.sin(dLat / 2), 2);
    var b = math.cos(l1) * math.cos(l0);
    var c = math.pow(math.sin(dLong / 2), 2);
    var sqrt = math.sqrt(a + b * c);
    return 2 * r * math.asin(sqrt);
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
    List<Post> out = [];

    for (var i = 0; i < lats.length; i++) {
      if (findDistance(lats[i], longs[i], pos.latitude, pos.longitude) <
          maxDist) {
        out.add(posts[i]);
      }
    }

    return out;
  }
}
