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
    k.add(
      const DrinkInfo(
        name: "진 토닉",
        img:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Gin_and_Tonic_with_ingredients.jpg/1280px-Gin_and_Tonic_with_ingredients.jpg",
        recipe: "이 거\n저거\n그거",
        desc: "진 과 토 닉 ",
      ),
    );
    k.add(
      const DrinkInfo(
        name: "마티니",
        img:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/15-09-26-RalfR-WLC-0084.jpg/220px-15-09-26-RalfR-WLC-0084.jpg",
        recipe: "진\n베르뭇",
        desc: "진 과 베 르 뭇",
      ),
    );
    k.add(
      const DrinkInfo(
        name: "롱 아일랜드 아이스 티",
        img:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Long_Island_Iced_Tea_2008.jpg/220px-Long_Island_Iced_Tea_2008.jpg",
        recipe: "진\n럼\n보드카\n데킬라\n기타등등",
        desc: "길다",
      ),
    );

    for (int i = 0; i < 6; ++i) {}

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

class DrinkInfo extends StatelessWidget {
  const DrinkInfo({
    Key? key,
    required this.name,
    required this.img,
    required this.desc,
    required this.recipe,
  }) : super(key: key);

  final String name;
  final String img;
  final String desc;
  final String recipe;

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(initialPage: 1),
      children: <Widget>[
        const SelectPage(),
        DrinkCard(
          name: name,
          img: img,
          desc: desc,
          recipe: recipe,
        ),
        const SocialPage(),
      ],
    );
  }
}

class SelectPage extends StatelessWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//      elevation: 1,
      child: Column(
        children: const <Widget>[
          Card(
            child: ListTile(
              title: Text("진"),
              subtitle: Text("맛있다"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("럼"),
              subtitle: Text("맛있다"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("보드카"),
              subtitle: Text("맛있다"),
            ),
          ),
          Card(
              child: ListTile(
            title: Text("데킬라"),
            subtitle: Text("맛있다"),
          )),
        ],
      ),
    );
  }
}

class DrinkCard extends StatefulWidget {
  const DrinkCard(
      {Key? key,
      required this.name,
      required this.img,
      required this.desc,
      required this.recipe})
      : super(key: key);

  final String name;
  final String img;
  final String desc;
  final String recipe;

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
              name: widget.name,
              img: widget.img,
              desc: widget.desc,
              onTap: onTap,
            )
          : RecipePage(
              name: widget.name,
              recipe: widget.recipe,
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
    required this.name,
    required this.img,
    required this.desc,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String img;
  final String desc;
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
                  image: NetworkImage(img),
                  height: 600,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Text(name),
              subtitle: Text(desc),
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
    required this.name,
    required this.recipe,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String recipe;
  final Function onTap;

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
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          children: <Widget>[
                ListTile(
                  title: Text(name),
                ),
              ] +
              widgets,
        ),
      ),
    );
  }
}

class SocialPage extends StatelessWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: const <Widget>[
        Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        ),
        Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        ),
        Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        )
      ]),
    );
  }
}
