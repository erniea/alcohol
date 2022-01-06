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

class DrinkMgr extends StatefulWidget {
  const DrinkMgr({Key? key}) : super(key: key);

  @override
  State<DrinkMgr> createState() => DrinkMgrState();
}

class DrinkMgrState extends State<DrinkMgr> {
  List<Drink> _drinks = [];
  List<Base> _bases = [];

  void addDrink(Drink d) {
    setState(() {
      _drinks.add(d);
    });
  }

  @override
  void initState() {
    super.initState();

    var drinkResponse = fetchDrink();
    drinkResponse.then((value) {
      setState(() {
        _drinks = value;
      });
    });
    var baseResponse = fetchBase();
    baseResponse.then((value) {
      setState(() {
        _bases = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    for (var d in _drinks) {
      widgets.add(
        Card(
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return RecipeInput(
                      drink: d,
                      bases: _bases,
                    );
                  });
            },
            child: ListTile(
              title: Text(d.name),
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
            child: const Text("추가"),
          )
        ],
      ),
    );
  }
}

class RecipeInput extends StatefulWidget {
  const RecipeInput({Key? key, required this.drink, required this.bases})
      : super(key: key);
  final Drink drink;
  final List<Base> bases;
  @override
  _RecipeInputState createState() => _RecipeInputState();
}

class _RecipeInputState extends State<RecipeInput> {
  List<int> selected = [];

  @override
  void initState() {
    super.initState();
    for (var r in widget.drink.recipe.elements) {
      selected.add(r.base.idx);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    for (int i = 0; i < widget.drink.recipe.elements.length; ++i) {
      widgets.add(Card(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        DropdownButton(
          value: selected[i],
          items: widget.bases.map((Base e) {
            return DropdownMenuItem(
              child: Text(e.name),
              value: e.idx,
            );
          }).toList(),
          onChanged: (int? v) {
            setState(() {
              selected[i] = v!;
            });
          },
        ),
        TextFormField(
          initialValue: widget.drink.recipe.elements[i].volume,
        )
      ])));
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: widgets +
            [
              ElevatedButton(
                onPressed: () {
                  var v = addRecipe(widget.drink.idx, 1, "");
                  v.then((value) {
                    log(value.body);
                  });
                  setState(() {
                    selected.add(1);
                  });
                },
                child: const Icon(Icons.add),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("완료"),
              )
            ],
      ),
    );
  }
}
