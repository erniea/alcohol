import 'package:alcohol/ds.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Base>> fetchBase() async {
  final response = await http.get(
    Uri.parse("https://alcohol.bada.works/api/bases/?format=json"),
  );
  var arr = json.decode(utf8.decode(response.bodyBytes))["results"];

  List<Base> bases = <Base>[];

  for (var v in arr) {
    bases.add(Base.fromJson(v));
  }
  return bases;
}

class SelectPage extends StatefulWidget {
  const SelectPage(
      {Key? key, required this.baseFilter, required this.setFilter})
      : super(key: key);
  final List<int> baseFilter;
  final Function setFilter;
  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  List<Base> bases = <Base>[];
  List<bool> checks = <bool>[];

  @override
  void initState() {
    super.initState();
    var result = fetchBase();
    result.then((value) {
      setState(() {
        bases = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (int i = 0; i < bases.length; ++i) {
      checks.add(widget.baseFilter.contains(bases[i].idx) ? false : true);

      if (bases[i].inStock) {
        widgets.add(SwitchListTile(
          title: Text(bases[i].name),
          onChanged: (bool value) {
            setState(() {
              checks[i] = value;
              widget.setFilter(value, bases[i].idx);
            });
          },
          value: checks[i],
        ));
      }
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
          padding: const EdgeInsets.all(10), child: Column(children: widgets)),
    );
  }
}
