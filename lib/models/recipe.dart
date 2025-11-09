import 'package:alcohol/models/base.dart';

class RecipeElement {
  final int idx;
  Base base;
  String volume;

  RecipeElement(this.idx, this.base, this.volume);

  factory RecipeElement.fromJson(Map<String, dynamic> j) {
    return RecipeElement(j["idx"], Base.fromJson(j["base"]), j["volume"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'base': base.toJson(),
      'volume': volume,
    };
  }
}

class Recipe {
  final List<RecipeElement> elements;

  factory Recipe.fromJson(List<dynamic> j) {
    var elements = <RecipeElement>[];
    for (var v in j) {
      var r = RecipeElement.fromJson(v);
      elements.add(r);
    }
    return Recipe(elements);
  }

  Recipe(this.elements);

  // 동적으로 계산되는 available getter
  bool get available {
    if (elements.isEmpty) return false;
    return elements.every((element) => element.base.inStock);
  }

  List<Map<String, dynamic>> toJson() {
    return elements.map((e) => e.toJson()).toList();
  }
}
