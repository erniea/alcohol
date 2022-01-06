import 'dart:developer';

import 'package:alcohol/drink.dart';
import 'package:alcohol/ds.dart';
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

class DrinkMgr extends StatefulWidget {
  const DrinkMgr({Key? key}) : super(key: key);

  @override
  State<DrinkMgr> createState() => DrinkMgrState();
}

class DrinkMgrState extends State<DrinkMgr> {
  List<Drink> _drinks = [];

  void addDrink(Drink d) {
    setState(() {
      _drinks.add(d);
    });
  }

  @override
  void initState() {
    super.initState();

    var response = fetchDrink();
    response.then((value) {
      setState(() {
        _drinks = value;
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
            onTap: () {},
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
  final TextEditingController controller = TextEditingController();

  void onSubmit(BuildContext context) {
    if (controller.text.isNotEmpty) {
      var response = addDrink(controller.text, "", "");
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
            controller: controller,
            autofocus: true,
            onSubmitted: (value) => onSubmit(context),
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
