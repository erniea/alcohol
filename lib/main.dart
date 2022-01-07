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
  int _page = 0;
  int _idx = 0;
  String _name = "";
  final List<DrinkCard> _drinkCards = <DrinkCard>[];
  final Set<int> _baseFilter = {};
  @override
  void initState() {
    super.initState();
    var result = fetchDrink();

    result.then((value) {
      setState(() {
        for (var d in value) {
          _drinkCards.add(DrinkCard(drink: d));
        }
        _idx = _drinkCards[0].drink.idx;
        _name = _drinkCards[0].drink.name;
      });
    });
  }

  void setFilter(bool isOn, int baseIdx) {
    setState(() {
      if (isOn) {
        _baseFilter.add(baseIdx);
      } else {
        _baseFilter.remove(baseIdx);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DrinkCard> drinksToShow = <DrinkCard>[];
    for (var drink in _drinkCards) {
      bool baseContained = false;
      if (_baseFilter.isNotEmpty) {
        for (int idx in _baseFilter) {
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
          baseFilter: _baseFilter,
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
                    _page = inPage;
                    _idx = drinksToShow[inPage].drink.idx;
                    _name = drinksToShow[inPage].drink.name;
                  });
                },
                controller: PageController(initialPage: _page),
                scrollDirection: Axis.vertical,
                children: drinksToShow,
              ),
              SocialPage(
                idx: _idx,
                name: _name,
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
  int _page = 0;
  final GlobalKey<BaseMgrState> _baseMgrState = GlobalKey();
  final GlobalKey<DrinkMgrState> _drinkMgrState = GlobalKey();

  Widget buildBottomSheet(BuildContext context) {
    switch (_page) {
      case 0:
        return BaseInput(baseMgrState: _baseMgrState);

      case 1:
        return DrinkInput(drinkMgrState: _drinkMgrState);
      default:
    }

    return Column(
      children: [
        ElevatedButton(onPressed: () {}, child: Text(_page.toString())),
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
                key: _baseMgrState,
              ),
              DrinkMgr(
                key: _drinkMgrState,
              )
            ],
            onPageChanged: (inPage) {
              setState(() {
                _page = inPage;
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
