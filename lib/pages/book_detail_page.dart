import 'package:flutter/material.dart';
import 'package:readeth/models/book_model.dart';

class BookDetailPage extends StatelessWidget {
  final BookModel book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Container
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                colorFilter:
                    ColorFilter.mode(Colors.black87, BlendMode.srcOver),
                image: NetworkImage(
                    "https://www.designforwriters.com/wp-content/uploads/2017/10/design-for-writers-book-cover-tf-2-a-million-to-one.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // Book Details
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://www.designforwriters.com/wp-content/uploads/2017/10/design-for-writers-book-cover-tf-2-a-million-to-one.jpg",
                  width: 200,
                  height: 400,
                ),
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                ),
                Text(book.author),
                Text(book.description),
                Text(book.publishDate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
