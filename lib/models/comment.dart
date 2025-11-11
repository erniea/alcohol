class Comment {
  final int idx;
  final String uid;
  final int star;
  final String comment;

  Comment(
    this.idx,
    this.uid,
    this.star,
    this.comment,
  );

  factory Comment.fromJson(Map<String, dynamic> j) {
    return Comment(
        j["idx"], j["uid"] ?? "", j["star"] ?? 0, j["comment"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'uid': uid,
      'star': star,
      'comment': comment,
    };
  }

  Comment copyWith({
    int? idx,
    String? uid,
    int? star,
    String? comment,
  }) {
    return Comment(
      idx ?? this.idx,
      uid ?? this.uid,
      star ?? this.star,
      comment ?? this.comment,
    );
  }
}
