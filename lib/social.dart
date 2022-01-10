import 'dart:developer';

import 'package:alcohol/ds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:http/http.dart' as http;
/*
Future<List<Comment>> fetchComment() async {
  final result = await http.get(
    Uri.parse('https://alcohol.bada.works/api/comments/?format=json'),
  );

  return [];
}
*/

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
  List<bool> _stars = [];

  @override
  void initState() {
    super.initState();
    _stars = List.filled(5, true);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(CommentCard(comment: Comment(1, "123", 5, "괜찮다")));
    widgets.add(CommentCard(comment: Comment(1, "456", 4, "괜찮다")));
    widgets.add(CommentCard(
        comment: Comment(1, "789", 2, "괜찮다 아주 길다란 코멘트와 함께 괜찮다는 별점을 남겨본다")));
    widgets.add(CommentCard(
        comment: Comment(2, "RZXV8gOEaTY0TaethFRm7DGZuTa2", 1, "별루다")));

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

  void _setStar(int i) {
    log(i.toString());
    setState(() {
      _stars[i] = !_stars[i];
    });
  }

  Widget _getWriteForm() {
    List<Widget> starForm = [];
    for (int i = 0; i < 5; ++i) {
      starForm.add(IconButton(
          onPressed: () {
            _setStar(i);
          },
          icon: _stars[i]
              ? const Icon(Icons.star)
              : const Icon(Icons.star_border)));
    }
    return Card(
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.star_border))
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({Key? key, required this.comment}) : super(key: key);
  final Comment comment;

  Widget _starToWidget() {
    List<Widget> result = [];

    for (int i = 0; i < comment.star; ++i) {
      result.add(const Icon(Icons.star));
    }

    result.add(Expanded(child: Container()));

    if (FirebaseAuth.instance.currentUser?.uid == comment.uid) {
      result.add(IconButton(onPressed: () {}, icon: const Icon(Icons.delete)));
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
