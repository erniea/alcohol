import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const Alcohol());
}

class Alcohol extends StatelessWidget {
  const Alcohol({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'alcohol',
      home: AlcoholDrinks(),
    );
  }
}

class AlcoholDrinks extends StatelessWidget {
  const AlcoholDrinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var k = <Widget>[];

    for (int i = 0; i < 6; ++i) {
      k.add(const DrinkPage(
        name: "진 토닉",
        recipe: "이 거\n저거\n그거",
      ));
    }

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          margin: const EdgeInsets.all(30),
          child: PageView(scrollDirection: Axis.vertical, children: k),
        ),
      ),
    );
  }
}

class DrinkPage extends StatelessWidget {
  const DrinkPage({
    Key? key,
    required this.name,
    required this.recipe,
  }) : super(key: key);

  final String name;
  final String recipe;

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(initialPage: 1),
      children: <Widget>[
        const SelectCard(),
        DrinkCard(name: name),
        RecipeCard(name: name, recipe: recipe)
      ],
    );
  }
}

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//      elevation: 1,
      child: Column(
        children: const <Widget>[
          ListTile(
            title: Text("진 토닉Gin Tonic"),
            subtitle: Text("진과 토닉을 섞어서 만든다"),
          ),
          Text("대충 술 고르는 페이지 .. ")
        ],
      ),
    );
  }
}

class DrinkCard extends StatelessWidget {
  const DrinkCard({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//      elevation: 20,
      child: Column(
        children: <Widget>[
          const Image(
            image: NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Gin_and_Tonic_with_ingredients.jpg/1024px-Gin_and_Tonic_with_ingredients.jpg"),
            height: 300,
          ),
          ListTile(
            title: Text(name),
            subtitle: const Text("진과 토닉을 섞어서 만든다"),
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
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.name,
    required this.recipe,
  }) : super(key: key);

  final String name;
  final String recipe;

  @override
  Widget build(BuildContext context) {
    var recipes = recipe.split("\n");

    var widgets = <Widget>[];
    for (var r in recipes) {
      widgets.add(Text(r));
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//      elevation: 20,
      child: Column(
        children: <Widget>[
              ListTile(
                title: Text(name),
                subtitle: const Text("진과 토닉을 섞어서 만든다"),
              ),
            ] +
            widgets,
      ),
    );
  }
}
