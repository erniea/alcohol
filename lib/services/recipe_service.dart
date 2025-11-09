import 'dart:convert';
import 'package:alcohol/core/constants/api_constants.dart';
import 'package:alcohol/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  /// 레시피 항목 추가
  Future<RecipeElement> addRecipe(int drinkIdx, int baseIdx, String volume) async {
    final response = await http.post(
      Uri.parse(ApiConstants.postRecipe),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'drink': drinkIdx,
        'base': baseIdx,
        'volume': volume,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var j = json.decode(utf8.decode(response.bodyBytes));
      return RecipeElement.fromJson(j);
    } else {
      throw Exception('Failed to add recipe: ${response.statusCode}');
    }
  }

  /// 레시피 항목 업데이트
  Future<void> updateRecipe(int recipeIdx, int baseIdx, String volume) async {
    final response = await http.patch(
      Uri.parse(ApiConstants.updateRecipe(recipeIdx)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'base': baseIdx,
        'volume': volume,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update recipe: ${response.statusCode}');
    }
  }

  /// 레시피 항목 삭제
  Future<void> deleteRecipe(int recipeIdx) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.deleteRecipe(recipeIdx)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete recipe: ${response.statusCode}');
    }
  }
}
