import 'package:flow/post.dart';

abstract class FilterAspect {
  List<Post> applyFilter(List<Post> posts);
}
