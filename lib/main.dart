import 'package:alcohol/baseMgr.dart';
import 'package:alcohol/drink.dart';
import 'package:alcohol/drinkMgr.dart';
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
        "/": (context) => StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? const AlcoholDrinks()
                    : const SignInScreen(
                        providerConfigs: [
                          GoogleProviderConfiguration(
                            clientId:
                                "920011687590-8t57g716g57grn0m1p2bsf4i48uleppd.apps.googleusercontent.com",
                          ),
                        ],
                      );
              },
            ),
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
/*     
 appBar: AppBar(
        title: const Text("alcohol.bada"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.login))],
      ),
      */
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
