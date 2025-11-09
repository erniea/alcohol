import 'package:alcohol/models/recipe.dart';

class Drink {
  final int idx;
  final String name;
  final String desc;
  final String img;
  final Recipe recipe;

  Drink(this.idx, this.name, this.desc, this.img, this.recipe);

  factory Drink.fromJson(Map<String, dynamic> j) {
    return Drink(
        j["idx"], j["name"], j["desc"], j["img"], Recipe.fromJson(j["recipe"]));
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'name': name,
      'desc': desc,
      'img': img,
      'recipe': recipe.toJson(),
    };
  }

  bool baseContains(int baseIdx) {
    for (RecipeElement r in recipe.elements) {
      if (r.base.idx == baseIdx) {
        return true;
      }
    }
    return false;
  }

  Drink copyWith({
    int? idx,
    String? name,
    String? desc,
    String? img,
    Recipe? recipe,
  }) {
    return Drink(
      idx ?? this.idx,
      name ?? this.name,
      desc ?? this.desc,
      img ?? this.img,
      recipe ?? this.recipe,
    );
  }
}
