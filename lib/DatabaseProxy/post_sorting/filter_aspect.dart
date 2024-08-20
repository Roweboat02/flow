import 'package:flow/Constructs/post.dart';

abstract class FilterAspect {
  Future<List<Post>> applyFilter(List<Post> posts);
}
