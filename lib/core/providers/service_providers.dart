import 'package:alcohol/services/base_service.dart';
import 'package:alcohol/services/comment_service.dart';
import 'package:alcohol/services/drink_service.dart';
import 'package:alcohol/services/recipe_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_providers.g.dart';

/// DrinkService 인스턴스 제공
@riverpod
DrinkService drinkService(Ref ref) {
  return DrinkService();
}

/// BaseService 인스턴스 제공
@riverpod
BaseService baseService(Ref ref) {
  return BaseService();
}

/// CommentService 인스턴스 제공
@riverpod
CommentService commentService(Ref ref) {
  return CommentService();
}

/// RecipeService 인스턴스 제공
@riverpod
RecipeService recipeService(Ref ref) {
  return RecipeService();
}
