import 'dart:developer';

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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView(
        children: widgets,
      ),
    );
  }
}

class BaseInput extends StatefulWidget {
  const BaseInput({Key? key}) : super(key: key);

  @override
  State<BaseInput> createState() => _BaseInputState();
}

class _BaseInputState extends State<BaseInput> {
  bool isInStock = true;
  TextEditingController controller = TextEditingController();

  void OnCommit() {
    log(controller.text);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              onSubmitted: (value) => OnCommit(),
            ),
            SwitchListTile(
                title: const Text("재고 여부"),
                value: isInStock,
                onChanged: (value) {
                  setState(() {
                    isInStock = value;
                  });
                }),
            ElevatedButton(
              onPressed: () => OnCommit,
              child: const Text("추가"),
            )
          ],
        ));
  }
}
