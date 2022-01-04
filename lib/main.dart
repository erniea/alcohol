import 'package:alcohol/drink.dart';
import 'package:alcohol/select.dart';
import 'package:alcohol/social.dart';

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

class AlcoholDrinks extends StatefulWidget {
  const AlcoholDrinks({Key? key}) : super(key: key);

  @override
  State<AlcoholDrinks> createState() => _AlcoholDrinksState();
}

class _AlcoholDrinksState extends State<AlcoholDrinks> {
  int page = 0;
  int idx = 0;
  String name = "";
  List<DrinkCard> drinkCard = <DrinkCard>[];

  @override
  void initState() {
    super.initState();
    var result = fetchDrink();

    result.then((value) {
      setState(() {
        drinkCard = value;
        idx = drinkCard[0].drink.idx;
        name = drinkCard[0].drink.name;
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
                    idx = drinkCard[inPage].drink.idx;
                    name = drinkCard[inPage].drink.name;
                  });
                },
                controller: PageController(initialPage: page),
                scrollDirection: Axis.vertical,
                children: drinkCard,
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
