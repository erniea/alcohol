import 'dart:html';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

Future<List<DrinkInfo>> fetchDrink() async {
  final response = await http.get(
    Uri.parse('https://alcohol.bada.works/api/drinks/?format=json'),
  );

  var arr = json.decode(utf8.decode(response.bodyBytes))["results"];

  List<DrinkInfo> drinkInfo = <DrinkInfo>[];

  for (var v in arr) {
    drinkInfo.add(DrinkInfo.fromJson(v));
  }

  return drinkInfo;
}

class AlcoholDrinks extends StatefulWidget {
  const AlcoholDrinks({Key? key}) : super(key: key);

  @override
  State<AlcoholDrinks> createState() => _AlcoholDrinksState();
}

class _AlcoholDrinksState extends State<AlcoholDrinks> {
  int page = 0;
  int idx = 0;
  String name = "";
  List<DrinkInfo> drinkInfo = <DrinkInfo>[];

  @override
  void initState() {
    super.initState();
    var result = fetchDrink();

    result.then((value) {
      setState(() {
        drinkInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /*
    drinkInfo.add(
      
      const DrinkInfo(
        idx: 0,
        name: "진 토닉",
        img:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Gin_and_Tonic_with_ingredients.jpg/1280px-Gin_and_Tonic_with_ingredients.jpg",
        recipe: "이 거\n저거\n그거",
        desc: "진 과 토 닉 ",
      ),
    );
    drinkInfo.add(
      const DrinkInfo(
        idx: 1,
        name: "마티니",
        img:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/15-09-26-RalfR-WLC-0084.jpg/220px-15-09-26-RalfR-WLC-0084.jpg",
        recipe: "진\n베르뭇",
        desc: "진 과 베 르 뭇",
      ),
    );
    drinkInfo.add(
      const DrinkInfo(
        idx: 2,
        name: "롱 아일랜드 아이스 티",
        img:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Long_Island_Iced_Tea_2008.jpg/220px-Long_Island_Iced_Tea_2008.jpg",
        recipe: "진\n럼\n보드카\n데킬라\n기타등등",
        desc: "길다",
      ),
    );
    drinkInfo.add(
      const DrinkInfo(
        idx: 3,
        name: "비트윈 더 쉬츠",
        img: "",
        recipe: "브랜디\n럼\n트리플 섹\n레몬주스",
        desc: "쓰까무라",
      ),
    );

    setState(() {
      name = drinkInfo[page].name;
    });

*/

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          margin: const EdgeInsets.all(30),
          child: PageView(
            controller: PageController(initialPage: 1),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SelectPage(),
              PageView(
                onPageChanged: (int inPage) {
                  setState(() {
                    page = inPage;
                    idx = drinkInfo[inPage].idx;
                    name = drinkInfo[inPage].name;
                  });
                },
                controller: PageController(initialPage: page),
                scrollDirection: Axis.vertical,
                children: drinkInfo,
              ),
              SocialPage(
                idx: idx,
                name: name,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrinkInfo extends StatelessWidget {
  const DrinkInfo({
    Key? key,
    required this.idx,
    required this.name,
    required this.img,
    required this.desc,
    required this.recipe,
  }) : super(key: key);

  factory DrinkInfo.fromJson(Map<String, dynamic> j) {
    return DrinkInfo(
        idx: j["idx"], name: j["name"], img: "", desc: "", recipe: j["recipe"]);
  }

  final int idx;
  final String name;
  final String img;
  final String desc;
  final String recipe;

  @override
  Widget build(BuildContext context) {
    return DrinkCard(
      name: name,
      img: img,
      desc: desc,
      recipe: recipe,
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
  const SocialPage({
    Key? key,
    required this.idx,
    required this.name,
  }) : super(key: key);

  final int idx;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: <Widget>[
        Text(name),
        Card(
          child: ListTile(
            title: Text(idx.toString()),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        )
      ]),
    );
  }
}
