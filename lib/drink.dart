import 'dart:convert';
import 'package:alcohol/ds.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<DrinkCard>> fetchDrink() async {
  final response = await http.get(
    Uri.parse('https://alcohol.bada.works/api/drinks/?format=json'),
  );

  var arr = json.decode(utf8.decode(response.bodyBytes))["results"];

  List<DrinkCard> drinkCard = <DrinkCard>[];

  for (var v in arr) {
    drinkCard.add(
      DrinkCard(
        drink: Drink.fromJson(v),
      ),
    );
  }
  drinkCard.sort((DrinkCard d1, DrinkCard d2) {
    return d1.drink.recipe.available == d2.drink.recipe.available ? -1 : 1;
  });

  return drinkCard;
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
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  splashRadius: 20,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  splashRadius: 20,
                ),
              ],
            )
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
      widgets.add(
        Text(r.toString(),
            style: r.base.inStock
                ? const TextStyle()
                : const TextStyle(decoration: TextDecoration.lineThrough)),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//      elevation: 20,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          children: <Widget>[
                ListTile(
                  title: Text(drink.name),
                ),
              ] +
              widgets,
        ),
      ),
    );
  }
}
