class Base {
  final String name;
  final bool inStock;

  Base(this.name, this.inStock);
  factory Base.fromJson(Map<String, dynamic> j) {
    return Base(j["name"], j["instock"]);
  }
}

class RecipeElement {
  final Base base;
  final String volume;

  RecipeElement(this.base, this.volume);

  factory RecipeElement.fromJson(Map<String, dynamic> j) {
    return RecipeElement(Base.fromJson(j["base"]), j["volume"]);
  }
  @override
  String toString() {
    return base.name + "\t" + volume;
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
    return Drink(j["idx"], j["name"], "", "", Recipe.fromJson(j["recipe"]));
  }
}
