import 'package:flutter/rendering.dart';

class Base {
  final int idx;
  final String name;
  final bool inStock;

  Base(this.idx, this.name, this.inStock);
  factory Base.fromJson(Map<String, dynamic> j) {
    return Base(j["idx"], j["name"], j["instock"]);
  }
}

class RecipeElement {
  final int idx;
  Base base;
  String volume;

  RecipeElement(this.idx, this.base, this.volume);

  factory RecipeElement.fromJson(Map<String, dynamic> j) {
    return RecipeElement(j["idx"], Base.fromJson(j["base"]), j["volume"]);
  }
}

class Recipe {
  final List<RecipeElement> elements;
  final bool available;
  factory Recipe.fromJson(List<dynamic> j) {
    bool available = true;
    var elements = <RecipeElement>[];
    for (var v in j) {
      var r = RecipeElement.fromJson(v);
      elements.add(r);
      available &= r.base.inStock;
    }
    return Recipe(elements, available);
  }
  Recipe(this.elements, this.available);
}

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

  bool baseContains(int baseIdx) {
    for (RecipeElement r in recipe.elements) {
      if (r.base.idx == baseIdx) {
        return true;
      }
    }
    return false;
  }
}

class Comment {
  final int idx;
  final String uid;
  final int star;
  final String comment;

  Comment(
    this.idx,
    this.uid,
    this.star,
    this.comment,
  );
}
