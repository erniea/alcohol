import 'package:alcohol/baseMgr.dart';
import 'package:alcohol/drink.dart';
import 'package:alcohol/drinkMgr.dart';
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
    return MaterialApp(
      title: 'alcohol',
      initialRoute: "/",
      routes: {
        "/": (context) => const AlcoholDrinks(),
        "/admin": (context) => const AlcoholAdmin(),
      },
      //home: AlcoholDrinks(),
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
  List<DrinkCard> drinkCards = <DrinkCard>[];
  Set<int> baseFilter = {};
  @override
  void initState() {
    super.initState();
    var result = fetchDrink();

    result.then((value) {
      setState(() {
        for (var d in value) {
          drinkCards.add(DrinkCard(drink: d));
        }
        idx = drinkCards[0].drink.idx;
        name = drinkCards[0].drink.name;
      });
    });
  }

  void setFilter(bool isOn, int baseIdx) {
    setState(() {
      if (isOn) {
        baseFilter.add(baseIdx);
      } else {
        baseFilter.remove(baseIdx);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DrinkCard> drinksToShow = <DrinkCard>[];
    for (var drink in drinkCards) {
      bool baseContained = false;
      if (baseFilter.isNotEmpty) {
        for (int idx in baseFilter) {
          baseContained |= drink.drink.baseContains(idx);
        }
        if (baseContained && drink.drink.recipe.available) {
          drinksToShow.add(drink);
        }
      } else {
        drinksToShow.add(drink);
      }
    }
    return Scaffold(
      drawer: Drawer(
        child: SelectPage(
          baseFilter: baseFilter,
          setFilter: setFilter,
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          margin: const EdgeInsets.all(30),
          child: PageView(
            controller: PageController(initialPage: 0),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              PageView(
                onPageChanged: (int inPage) {
                  setState(() {
                    page = inPage;
                    idx = drinksToShow[inPage].drink.idx;
                    name = drinksToShow[inPage].drink.name;
                  });
                },
                controller: PageController(initialPage: page),
                scrollDirection: Axis.vertical,
                children: drinksToShow,
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

class AlcoholAdmin extends StatefulWidget {
  const AlcoholAdmin({Key? key}) : super(key: key);

  @override
  State<AlcoholAdmin> createState() => _AlcoholAdminState();
}

class _AlcoholAdminState extends State<AlcoholAdmin> {
  int page = 0;
  GlobalKey<BaseMgrState> baseMgrState = GlobalKey();
  GlobalKey<DrinkMgrState> drinkMgrState = GlobalKey();

  Widget buildBottomSheet(BuildContext context) {
    switch (page) {
      case 0:
        return BaseInput(baseMgrState: baseMgrState);

      case 1:
        return DrinkInput(drinkMgrState: drinkMgrState);
      default:
    }

    return Column(
      children: [
        ElevatedButton(onPressed: () {}, child: Text(page.toString())),
        ElevatedButton(onPressed: () {}, child: const Text("레시피")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          margin: const EdgeInsets.all(30),
          child: PageView(
            controller: PageController(initialPage: 0),
            children: [
              BaseMgr(
                key: baseMgrState,
              ),
              DrinkMgr(
                key: drinkMgrState,
              )
            ],
            onPageChanged: (inPage) {
              setState(() {
                page = inPage;
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: buildBottomSheet);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
