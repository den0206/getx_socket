/// pagination　用クラス
class Pages<T> {
  final List<T> pageFeeds;
  final PageInfo pageInfo;

  Pages(this.pageFeeds, this.pageInfo);

  factory Pages.fromMap(Map<String, dynamic> map, Function fromJsonModel) {
    final items = map['pageFeeds'].cast<Map<String, dynamic>>();
    return Pages(
      List<T>.from(items.map((itemsJson) => fromJsonModel(itemsJson))),
      PageInfo.fromMap(map['pageInfo']),
    );
  }
}

class PageInfo {
  PageInfo({
    required this.nextPageCursor,
    required this.hasNextPage,
  });

  final String? nextPageCursor;
  final bool hasNextPage;

  factory PageInfo.fromMap(Map<String, dynamic> json) => PageInfo(
        nextPageCursor: json["nextPageCursor"],
        hasNextPage: json["hasNextPage"],
      );

  Map<String, dynamic> toMap() => {
        "nextPageCursor": nextPageCursor,
        "hasNextPage": hasNextPage,
      };
}
