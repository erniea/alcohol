import 'dart:convert';
import 'dart:developer';

import 'package:alcohol/ds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:http/http.dart' as http;

Future<List<Comment>> fetchComment(int idx) async {
  final result = await http.get(
    Uri.parse('https://alcohol.bada.works/api/comments/?search=$idx'),
  );

  var results = json.decode(utf8.decode(result.bodyBytes))["results"];

  List<Comment> list = [];
  for (var r in results) {
    list.add(Comment.fromJson(r));
  }
  return list;
}

Future<http.Response> addComment(
    int drinkIdx, String uid, int star, String comment) {
  return http.post(
    Uri.parse('https://alcohol.bada.works/api/comments/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'drink': drinkIdx,
      'uid': uid,
      'star': star,
      'comment': comment
    }),
  );
}

Future<http.Response> deleteComment(int idx) {
  return http.delete(
    Uri.parse('https://alcohol.bada.works/api/comments/$idx/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

class SocialPage extends StatefulWidget {
  const SocialPage({
    Key? key,
    required this.drink,
  }) : super(key: key);

  final Drink drink;

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  List<Comment> _comments = [];

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var comments = fetchComment(widget.drink.idx);

    comments.then((value) {
      setState(() {
        _comments = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widgets.add(Text(widget.drink.name));

    for (var c in _comments) {
      widgets.add(CommentCard(comment: c, onDelete: _onDelete));
    }

    widgets.add(Expanded(child: Container()));
    widgets.add(_getWriteForm());
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Column(children: widgets)
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
    );
  }

  int _star = 5;
  void _setStar(int i) {
    setState(() {
      _star = i + 1;
    });
  }

  void _onSubmit() {
    var result = addComment(widget.drink.idx,
        (FirebaseAuth.instance.currentUser?.uid)!, _star, textController.text);

    result.then((value) {
      var idx = json.decode(utf8.decode(value.bodyBytes))["idx"];
      setState(() {
        _comments.add(Comment(idx, (FirebaseAuth.instance.currentUser?.uid)!,
            _star, textController.text));
        textController.text = "";
      });
    });
  }

  void _onDelete(Comment commentToDelete) {
    setState(() {
      _comments.removeAt(_comments.indexOf(commentToDelete));
    });
  }

  Widget _getWriteForm() {
    List<Widget> starForm = [];
    for (int i = 0; i < 5; ++i) {
      starForm.add(IconButton(
          onPressed: () {
            _setStar(i);
          },
          icon: _star > i
              ? const Icon(Icons.star)
              : const Icon(Icons.star_border)));
    }
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: starForm,
        ),
        TextField(
          controller: textController,
          onSubmitted: (value) {
            _onSubmit();
          },
        ),
        ElevatedButton(
            onPressed: () {
              _onSubmit();
            },
            child: const Text("Comment"))
      ]),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({Key? key, required this.comment, required this.onDelete})
      : super(key: key);
  final Comment comment;
  final Function onDelete;
  Widget _starToWidget() {
    List<Widget> result = [];

    for (int i = 0; i < comment.star; ++i) {
      result.add(const Icon(Icons.star));
    }

    result.add(Expanded(child: Container()));

    if (FirebaseAuth.instance.currentUser?.uid == comment.uid) {
      result.add(IconButton(
          onPressed: () {
            deleteComment(comment.idx);
            onDelete(comment);
          },
          icon: const Icon(Icons.delete)));
    }
    return Row(
      children: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: _starToWidget(),
        subtitle: Text(comment.comment),
      ),
    );
  }
}
