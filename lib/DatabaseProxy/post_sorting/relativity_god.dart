import 'package:flow/Constructs/post.dart';
import 'package:flow/DatabaseProxy/post_sorting/distance_aspect.dart';
import 'package:flow/DatabaseProxy/post_sorting/filter_aspect.dart';

class RelativityGod {
  List<FilterAspect> filters = [DistanceAspect()];

  Future<List<Post>> sort(List<Post> posts) async {
    for (FilterAspect f in filters) {
      posts = await f.applyFilter(posts);
    }
    return posts;
  }
}
