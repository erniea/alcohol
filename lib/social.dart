import 'dart:html';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({
    Key? key,
    required this.idx,
    required this.name,
  }) : super(key: key);

  final int idx;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: <Widget>[
        Text(name),
        Card(
          child: ListTile(
            title: Text(idx.toString()),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text("누구누구"),
            subtitle: Text("맛있다"),
          ),
        )
      ]),
    );
  }
}
