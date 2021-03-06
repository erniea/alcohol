import 'dart:developer';

import 'package:alcohol/drink.dart';
import 'package:alcohol/ds.dart';
import 'package:alcohol/select.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> addDrink(String name, String img, String desc) {
  return http.post(
    Uri.parse('https://alcohol.bada.works/api/postdrink/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'img': img,
      'desc': desc,
    }),
  );
}

Future<http.Response> addRecipe(int drinkIdx, int baseIdx, String volume) {
  return http.post(
    Uri.parse('https://alcohol.bada.works/api/postrecipe/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'drink': drinkIdx,
      'base': baseIdx,
      'volume': volume,
    }),
  );
}

Future<http.Response> deleteRecipe(int recipeIdx) {
  return http.delete(
    Uri.parse('https://alcohol.bada.works/api/postrecipe/$recipeIdx/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

Future<http.Response> updateRecipe(int recipeIdx, int baseIdx, String volume) {
  return http.patch(
    Uri.parse('https://alcohol.bada.works/api/postrecipe/$recipeIdx/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'base': baseIdx,
      'volume': volume,
    }),
  );
}

class DrinkMgr extends StatefulWidget {
  const DrinkMgr({Key? key}) : super(key: key);

  @override
  State<DrinkMgr> createState() => DrinkMgrState();
}

class DrinkMgrState extends State<DrinkMgr> {
  List<Drink> _drinks = [];
  List<Base> _bases = [];
  Drink? _selectedDrink;
  bool _isFront = true;

  void addDrink(Drink d) {
    setState(() {
      _drinks.add(d);
    });
  }

  Widget _flipAnimation() {
    onTap() => setState(() {
          _isFront = !_isFront;
        });

    return GestureDetector(
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _isFront
                ? DrinkListPage(
                    drinks: _drinks,
                    onTap: (Drink drink) {
                      _selectedDrink = drink;
                      onTap();
                    },
                  )
                : RecipeEditPage(
                    drink: _selectedDrink!,
                    bases: _bases,
                    onTap: onTap,
                  )));
  }

  @override
  void initState() {
    super.initState();

    var drinkResult = fetchDrink();
    drinkResult.then((value) {
      setState(() {
        _drinks = value;
      });
    });
    var baseResult = fetchBase();
    baseResult.then((value) {
      setState(() {
        _bases = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _flipAnimation();
  }
}

class DrinkListPage extends StatelessWidget {
  const DrinkListPage({Key? key, required this.drinks, required this.onTap})
      : super(key: key);
  final List<Drink> drinks;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    for (var drink in drinks) {
      widgets.add(
        Card(
          child: InkWell(
            onTap: () {
              onTap(drink);
            },
            child: ListTile(
              title: Text(drink.name),
            ),
          ),
        ),
      );
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView(
        children: widgets,
      ),
    );
  }
}

class DrinkInput extends StatefulWidget {
  const DrinkInput({Key? key, required this.drinkMgrState}) : super(key: key);
  final GlobalKey<DrinkMgrState> drinkMgrState;
  @override
  State<DrinkInput> createState() => _DrinkInputState();
}

class _DrinkInputState extends State<DrinkInput> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imgController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  void onSubmit(BuildContext context) {
    if (nameController.text.isNotEmpty) {
      var response = addDrink(
          nameController.text, imgController.text, descController.text);
      response.then((value) {
        var j = json.decode(utf8.decode(value.bodyBytes));
        var recipe = Recipe([], true);
        widget.drinkMgrState.currentState
            ?.addDrink(Drink(j["idx"], j["name"], j["img"], j["desc"], recipe));
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: imgController,
            decoration: const InputDecoration(hintText: 'Img'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(hintText: 'Desc'),
          ),
          ElevatedButton(
            onPressed: () => onSubmit(context),
            child: const Text("??????"),
          )
        ],
      ),
    );
  }
}

class RecipeEditPage extends StatefulWidget {
  const RecipeEditPage(
      {Key? key, required this.drink, required this.bases, required this.onTap})
      : super(key: key);
  final Drink drink;
  final List<Base> bases;
  final Function onTap;

  @override
  _RecipeEditPageState createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  Map<int, int> selected = {};
  Map<int, TextEditingController> textControllers = {};
  List<TextEditingController> text = [];
  List<RecipeElement> deleted = [];

  @override
  void initState() {
    super.initState();
    for (var recipe in widget.drink.recipe.elements) {
      selected[recipe.idx] = recipe.base.idx;
      textControllers[recipe.idx] = TextEditingController(text: recipe.volume);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widgets.add(
      Card(
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.drink.img,
              decoration: const InputDecoration(hintText: "img"),
            ),
            TextFormField(
              initialValue: widget.drink.desc,
              decoration: const InputDecoration(hintText: "desc"),
            )
          ],
        ),
      ),
    );

    for (int i = 0; i < widget.drink.recipe.elements.length; ++i) {
      if (!deleted.contains(widget.drink.recipe.elements[i])) {
        widgets.add(
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.drink.recipe.elements[i].idx.toString()),
                Row(children: [
                  DropdownButton(
                    value: selected[widget.drink.recipe.elements[i].idx],
                    items: widget.bases.map((Base base) {
                      return DropdownMenuItem(
                        child: Text(base.name),
                        value: base.idx,
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        selected[widget.drink.recipe.elements[i].idx] = value!;
                      });
                    },
                  ),
                  Expanded(child: Container()),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          deleted.add(widget.drink.recipe.elements[i]);
                        });
                      },
                      icon: const Icon(Icons.remove))
                ]),
                TextField(
                  controller:
                      textControllers[widget.drink.recipe.elements[i].idx],
                )
              ],
            ),
          ),
        );
      }
    }
    void commit() {
      for (var recipe in deleted) {
        deleteRecipe(recipe.idx);
        setState(() {
          widget.drink.recipe.elements.remove(recipe);
        });
      }

      for (var recipe in widget.drink.recipe.elements) {
        updateRecipe(recipe.idx, selected[recipe.idx]!,
            (textControllers[recipe.idx]?.text)!);
        setState(() {
          recipe.base = Base(selected[recipe.idx]!, "", true);
          recipe.volume = (textControllers[recipe.idx]?.text)!;
        });
      }
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: ListView(
          children: widgets +
              [
                ElevatedButton(
                  onPressed: () {
                    var result =
                        addRecipe(widget.drink.idx, widget.bases.first.idx, "");
                    result.then((value) {
                      var j = json.decode(utf8.decode(value.bodyBytes));

                      setState(() {
                        widget.drink.recipe.elements.add(RecipeElement(
                            j["idx"], widget.bases.first, j["volume"]));

                        selected[j["idx"]] = widget.bases.first.idx;
                        textControllers[j["idx"]] = TextEditingController();
                      });
                    });
                  },
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    commit();
                    widget.onTap();
                  },
                  child: const Text("??????"),
                )
              ],
        ),
      ),
    );
  }
}
