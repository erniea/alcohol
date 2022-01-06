import 'package:alcohol/ds.dart';
import 'package:alcohol/select.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> updateBaseInStock(int idx, bool inStock) {
  return http.patch(
    Uri.parse('https://alcohol.bada.works/api/postbase/$idx/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'instock': inStock.toString(),
    }),
  );
}

Future<http.Response> updateBaseName(int idx, String name) {
  return http.patch(
    Uri.parse('https://alcohol.bada.works/api/postbase/$idx/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
    }),
  );
}

Future<http.Response> addBase(String name, bool inStock) {
  return http.post(
    Uri.parse('https://alcohol.bada.works/api/postbase/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'instock': inStock.toString(),
    }),
  );
}

class BaseMgr extends StatefulWidget {
  const BaseMgr({Key? key}) : super(key: key);

  @override
  BaseMgrState createState() => BaseMgrState();
}

class BaseMgrState extends State<BaseMgr> {
  List<Base> bases = <Base>[];
  List<bool> checks = <bool>[];

  void addBase(Base b) {
    setState(() {
      bases.add(b);
      checks.add(b.inStock);
    });
  }

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
            onChanged: (value) {
              updateBaseName(bases[i].idx, value);
            },
          ),
          value: checks[i],
          onChanged: (value) {
            setState(() {
              checks[i] = value;
            });
            updateBaseInStock(bases[i].idx, value);
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
  const BaseInput({Key? key, required this.baseMgrState}) : super(key: key);

  final GlobalKey<BaseMgrState> baseMgrState;

  @override
  State<BaseInput> createState() => _BaseInputState();
}

class _BaseInputState extends State<BaseInput> {
  bool inStock = true;
  TextEditingController controller = TextEditingController();

  void onSubmit(BuildContext context) {
    if (controller.text.isNotEmpty) {
      var response = addBase(controller.text, inStock);

      response.then((value) {
        var j = json.decode(utf8.decode(value.bodyBytes));
        widget.baseMgrState.currentState
            ?.addBase(Base(j["idx"], j["name"], j["instock"]));
      });
      Navigator.pop(context);
    }
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
              onSubmitted: (value) => onSubmit(context),
            ),
            SwitchListTile(
                title: const Text("재고 여부"),
                value: inStock,
                onChanged: (value) {
                  setState(() {
                    inStock = value;
                  });
                }),
            ElevatedButton(
              onPressed: () => onSubmit(context),
              child: const Text("추가"),
            )
          ],
        ));
  }
}
