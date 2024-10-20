import 'package:flutter/material.dart';
import 'package:readeth/bloc/book_bloc.dart';
import 'package:readeth/bloc/book_event.dart';
import 'package:readeth/models/book_model.dart';
import 'package:readeth/pages/edit_book_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:readeth/utils/show_toast.dart';
import 'package:readeth/widgets/app_drawer.dart';

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
                    "https://m.media-amazon.com/images/I/71OVB8HknWL._AC_UF1000,1000_QL80_.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Book Details with scroll
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60), // Leave space for back button
                  Center(
                    child: Image.network(
                      "https://m.media-amazon.com/images/I/71OVB8HknWL._AC_UF1000,1000_QL80_.jpg",
                      width: 200,
                      height: 400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  Text(book.author),
                  Text(
                    book.description,
                    textAlign: TextAlign.justify,
                  ),
                  Text(book.publishDate),
                  GestureDetector(
                    onTap: () {
                      showModal(context, book);
                    },
                    child: const Text(
                      "Delete Book",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          // Back Button positioned at the top
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                print("going back");
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Edit Book",
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffFFF279),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditBookPage(book: book)));
        },
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      ),
    );
  }
}

// show confirmation modal
void showModal(BuildContext context, BookModel book) {

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          elevation: 10,
          icon: const Icon(Icons.delete),
          title: const Text("Delete Book"),
          content: const Text("Are you sure you want to delete the book ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                context.read<BookBloc>().add(DeleteBookEvent(book));
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AppDrawer()));
                showScaffoldSnackBar(
                    context, "${book.title} is deleted", Colors.red);
              },
              child: const Text(
                "Yes, Sure",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            )
          ],
        );
      });
}
