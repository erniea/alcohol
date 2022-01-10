import 'package:alcohol/baseMgr.dart';
import 'package:alcohol/drink.dart';
import 'package:alcohol/drinkMgr.dart';
import 'package:alcohol/ds.dart';
import 'package:alcohol/select.dart';
import 'package:alcohol/social.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBjW3tGd88Z3VL5rJSuPfwPUsT5lzWrBzs",
        authDomain: "alcohol-bada.firebaseapp.com",
        projectId: "alcohol-bada",
        storageBucket: "alcohol-bada.appspot.com",
        messagingSenderId: "920011687590",
        appId: "1:920011687590:web:818405bc02ec38a5111667",
        measurementId: "G-40GSPC0MRH"),
  );
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
  Drink _currentDrink = Drink(0, "", "", "", Recipe([], true));
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
        _currentDrink = drinkCards.first.drink;
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
      appBar: AppBar(
        title: const Text("alcohol.bada"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
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
                    _currentDrink = drinksToShow[inPage].drink;
                  });
                },
                controller: PageController(initialPage: _page),
                scrollDirection: Axis.vertical,
                children: drinksToShow,
              ),
              SocialPage(
                drink: _currentDrink,
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
            controller: PageController(initialPage: 1),
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
