import 'package:alcohol/services/base_service.dart';
import 'package:alcohol/services/comment_service.dart';
import 'package:alcohol/services/drink_service.dart';
import 'package:alcohol/services/recipe_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_providers.g.dart';

/// DrinkService 인스턴스 제공
@riverpod
DrinkService drinkService(DrinkServiceRef ref) {
  return DrinkService();
}

/// BaseService 인스턴스 제공
@riverpod
BaseService baseService(BaseServiceRef ref) {
  return BaseService();
}

/// CommentService 인스턴스 제공
@riverpod
CommentService commentService(CommentServiceRef ref) {
  return CommentService();
}

/// RecipeService 인스턴스 제공
@riverpod
RecipeService recipeService(RecipeServiceRef ref) {
  return RecipeService();
}
