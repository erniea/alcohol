import 'package:alcohol/ds.dart';
import 'package:alcohol/select.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class BaseMgr extends StatefulWidget {
  const BaseMgr({Key? key}) : super(key: key);

  @override
  _BaseMgrState createState() => _BaseMgrState();
}

class _BaseMgrState extends State<BaseMgr> {
  List<Base> bases = <Base>[];
  List<bool> checks = <bool>[];
  @override
  void initState() {
    super.initState();
    var result = fetchBase();
    result.then((value) {
      for (var base in value) {
        checks.add(base.inStock);
      }
      setState(() {
        bases = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    for (int i = 0; i < bases.length; ++i) {
      widgets.add(
        SwitchListTile(
          title: TextFormField(
            initialValue: bases[i].name,
          ),
          value: checks[i],
          onChanged: (value) {
            setState(() {
              checks[i] = value;
            });
          },
        ),
      );
    }

    widgets.add(FloatingActionButton(
        onPressed: () {
          var result = fetchBase();
          result.then((value) {
            setState(() {
              bases = value;
            });
          });
        },
        child: Icon(Icons.add)));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView(
        children: widgets,
      ),
    );
  }
}
