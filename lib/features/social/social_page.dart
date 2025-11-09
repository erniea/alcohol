import 'dart:convert';
import 'package:alcohol/models/comment.dart';
import 'package:alcohol/models/drink.dart';
import 'package:alcohol/services/comment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

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

  final _commentService = CommentService();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((event) {
      _loadComments();
    });
  }

  @override
  void didUpdateWidget(SocialPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // drink가 변경되면 새로운 코멘트 로드
    if (oldWidget.drink.idx != widget.drink.idx) {
      _loadComments();
    }
  }

  Future<void> _loadComments() async {
    try {
      final comments = await _commentService.fetchComments(widget.drink.idx);
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      // 에러 처리 (인증되지 않은 경우 등)
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    int stars = 0;
    for (var c in _comments) {
      widgets.add(CommentCard(comment: c, onDelete: _onDelete));
      stars += c.star;
    }

    if (_comments.isNotEmpty) {
      widgets.insert(
          0,
          CommentCard(
            comment:
                Comment(0, "", (stars / _comments.length).round(), "평균 평점"),
            onDelete: () {},
          ));
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Column(children: [
                  Text(widget.drink.name),
                  Expanded(
                    child: ListView(
                      children: widgets,
                      shrinkWrap: true,
                      //physics: ClampingScrollPhysics(),
                    ),
                  ),
                  _getWriteForm()
                ])
              : const SignInScreen();
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

  Future<void> _onSubmit() async {
    try {
      final newComment = await _commentService.addComment(
        widget.drink.idx,
        FirebaseAuth.instance.currentUser!.uid,
        _star,
        textController.text,
      );

      setState(() {
        _comments.add(newComment);
        textController.text = "";
      });
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('코멘트 추가 실패: $e')),
        );
      }
    }
  }

  Future<void> _onDelete(Comment commentToDelete) async {
    try {
      await _commentService.deleteComment(commentToDelete.idx);
      setState(() {
        _comments.removeAt(_comments.indexOf(commentToDelete));
      });
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('코멘트 삭제 실패: $e')),
        );
      }
    }
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
