import 'package:flow/post.dart';

abstract class FilterAspect {
  Future<List<Post>> applyFilter(List<Post> posts);
}
