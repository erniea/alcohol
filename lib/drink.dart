import 'dart:convert';
import 'package:alcohol/ds.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<Drink>> fetchDrink() async {
  final response = await http.get(
    Uri.parse('https://alcohol.bada.works/api/drinks/?format=json'),
  );

  var results = json.decode(utf8.decode(response.bodyBytes))["results"];

  List<Drink> drinks = <Drink>[];

  for (var result in results) {
    drinks.add(
      Drink.fromJson(result),
    );
  }
  drinks.sort((Drink d1, Drink d2) {
    return d1.recipe.available == d2.recipe.available ? 1 : -1;
  });

  return drinks;
}

class DrinkCard extends StatefulWidget {
  const DrinkCard({
    Key? key,
    required this.drink,
  }) : super(key: key);

  final Drink drink;
  @override
  State<StatefulWidget> createState() => _DrinkCardState();
}

class _DrinkCardState extends State<DrinkCard> {
  bool _isFront = true;
  Widget _flipAnimation() {
    onTap() => setState(() {
          _isFront = !_isFront;
        });

    return GestureDetector(
        child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _isFront
          ? DetailPage(
              drink: widget.drink,
              onTap: onTap,
            )
          : RecipePage(
              drink: widget.drink,
              onTap: onTap,
            ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _flipAnimation();
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({
    Key? key,
    required this.drink,
    required this.onTap,
  }) : super(key: key);

  final Drink drink;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 16),
                child: Image(
                  image: NetworkImage(drink.img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Text(
                drink.name,
                style: const TextStyle(fontSize: 50),
              ),
              subtitle: Text(drink.desc),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipePage extends StatelessWidget {
  const RecipePage({
    Key? key,
    required this.drink,
    required this.onTap,
  }) : super(key: key);

  final Drink drink;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (var r in drink.recipe.elements) {
      var style = r.base.inStock
          ? const TextStyle(fontSize: 20)
          : const TextStyle(
              fontSize: 20, decoration: TextDecoration.lineThrough);
      widgets.add(
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Text(r.base.name, style: style),
              Expanded(child: Container()),
              Text(r.volume, style: style)
            ],
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
                  Text(drink.name),
                ] +
                widgets,
          ),
        ),
      ),
    );
  }
}
