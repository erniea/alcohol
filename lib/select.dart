import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//      elevation: 1,
      child: Column(
        children: const <Widget>[
          Card(
            child: ListTile(
              title: Text("진"),
              subtitle: Text("맛있다"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("럼"),
              subtitle: Text("맛있다"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("보드카"),
              subtitle: Text("맛있다"),
            ),
          ),
          Card(
              child: ListTile(
            title: Text("데킬라"),
            subtitle: Text("맛있다"),
          )),
        ],
      ),
    );
  }
}
