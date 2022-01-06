import 'package:alcohol/drink.dart';
import 'package:alcohol/ds.dart';
import 'package:flutter/material.dart';

class DrinkMgr extends StatefulWidget {
  const DrinkMgr({Key? key}) : super(key: key);

  @override
  State<DrinkMgr> createState() => _DrinkMgrState();
}

class _DrinkMgrState extends State<DrinkMgr> {
  List<Drink> _drinks = [];

  @override
  void initState() {
    super.initState();

    var response = fetchDrink();
    response.then((value) {
      setState(() {
        _drinks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    for (var d in _drinks) {
      widgets.add(
        Card(
          child: InkWell(
            onTap: () {},
            child: ListTile(
              title: Text(d.name),
            ),
          ),
        ),
      );
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView(
        children: widgets,
      ),
    );
  }
}
