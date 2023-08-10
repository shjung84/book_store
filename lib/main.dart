import 'package:book_store/book_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'book.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  /// 검색 함수
  /// 엔터를 누르거나 돋보기 아이콘을 누를 때 호출
  void search(BookService bookService) {
    String keyword = searchController.text; // 검색어
    if (keyword.isNotEmpty) {
      bookService.getBookList(keyword); // 책 검색
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(
      builder: (context, bookService, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              '책 목록',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  "총 ${bookService.bookList.length}권",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 72),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: '책 제목을 입력하세요.',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // 돋보기 아이콘을 눌렀을 때
                        search(bookService);
                      },
                    ),
                  ),
                  onSubmitted: (v) {
                    // 엔터를 눌렀을 때
                    search(bookService);
                  },
                ),
              ),
            ),
          ),
          body: bookService.bookList.isEmpty
              ? Center(
                  child: Text(
                    "검색어를 입력해 주세요.",
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: bookService.bookList.length,
                  itemBuilder: (context, index) {
                    Book book = bookService.bookList[index];
                    return ListTile(
                      leading: Image.network(
                        book.thumbnail,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      title: Text(book.title),
                      subtitle: Text(book.subtitle),
                      onTap: () {
                        // 클릭시 previewLink 띄우기
                        Uri uri = Uri.parse(book.previewLink);
                        launchUrl(uri);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
