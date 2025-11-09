import 'dart:convert';
import 'package:alcohol/core/constants/api_constants.dart';
import 'package:alcohol/models/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class CommentService {
  /// 특정 칵테일의 코멘트 조회
  Future<List<Comment>> fetchComments(int drinkIdx) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final result = await http.get(
      Uri.parse(ApiConstants.drinkComments(drinkIdx)),
      headers: {"Authorization": idToken},
    );

    if (result.statusCode == 200) {
      var results = json.decode(utf8.decode(result.bodyBytes))["results"];
      List<Comment> list = [];

      for (var r in results) {
        list.add(Comment.fromJson(r));
      }

      return list;
    } else {
      throw Exception('Failed to load comments: ${result.statusCode}');
    }
  }

  /// 코멘트 추가
  Future<Comment> addComment(
      int drinkIdx, String uid, int star, String comment) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse(ApiConstants.comments),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": idToken,
      },
      body: jsonEncode(<String, dynamic>{
        'drink': drinkIdx,
        'uid': uid,
        'star': star,
        'comment': comment
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var j = json.decode(utf8.decode(response.bodyBytes));
      return Comment.fromJson(j);
    } else {
      throw Exception('Failed to add comment: ${response.statusCode}');
    }
  }

  /// 코멘트 삭제
  Future<void> deleteComment(int idx) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.delete(
      Uri.parse(ApiConstants.deleteComment(idx)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": idToken,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete comment: ${response.statusCode}');
    }
  }
}
