class Base {
  final int idx;
  final String name;
  final bool inStock;

  Base(this.idx, this.name, this.inStock);

  factory Base.fromJson(Map<String, dynamic> j) {
    return Base(j["idx"], j["name"] ?? "", j["instock"] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'name': name,
      'instock': inStock,
    };
  }

  Base copyWith({
    int? idx,
    String? name,
    bool? inStock,
  }) {
    return Base(
      idx ?? this.idx,
      name ?? this.name,
      inStock ?? this.inStock,
    );
  }
}
