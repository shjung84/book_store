class Book {
  String title;
  String subtitle;
  String thumbnail;
  String previewLink;

  Book({
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.previewLink,
  });

  // Map<String, dynamic>을 전달받아 Book 클래스 인스턴스를 반환하는 함수
  // factory 키워드를 붙여서 생성자로 사용
  factory Book.fromJson(Map<String, dynamic> volumeInfo) {
    return Book(
      // title이 없는 경우 빈 문자열 할당
      title: volumeInfo["title"] ?? "",
      // subtitle이 없는 경우 빈 문자열 할당
      subtitle: volumeInfo["subtitle"] ?? "",
      // imageLisks 또는 thumbnail이 없을 때 빈 이미지 추가
      thumbnail: volumeInfo["imageLinks"]?["thumbnail"] ??
          "https://i.ibb.co/2ypYwdr/no-photo.png",
      // previewLink가 없는 경우 빈 문자열 할당
      previewLink: volumeInfo["previewLink"] ?? "",
    );
  }
}
