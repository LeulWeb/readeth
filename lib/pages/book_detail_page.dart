import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readeth/bloc/book_bloc.dart';
import 'package:readeth/bloc/book_event.dart';
import 'package:readeth/config/app_resources.dart';
import 'package:readeth/models/book_model.dart';
import 'package:readeth/pages/edit_book_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readeth/pages/pdf_viewer_page.dart';

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
          // Background image
          FutureBuilder<bool>(
            future: File(book.coverImage ?? "").exists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text("Error checking file");
              } else if (snapshot.data == true) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter:
                          ColorFilter.mode(Colors.black87, BlendMode.srcOver),
                      image: FileImage(File(book.coverImage!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                return Container(
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
                );
              }
            },
          ),

          // Book Details with scroll
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center contents vertically
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80), // Leave space for back button
                      FutureBuilder<bool>(
                        future: File(book.coverImage ?? "").exists(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Text("Error checking file");
                          } else if (snapshot.data == true) {
                            return Image.file(
                              File(book.coverImage!),
                              fit: BoxFit.cover,
                              width: 200,
                              height: 300,
                            );
                          } else {
                            return Image.network(
                              "https://m.media-amazon.com/images/I/71OVB8HknWL._AC_UF1000,1000_QL80_.jpg",
                              fit: BoxFit.cover,
                              width: 200,
                              height: 300,
                            );
                          }
                        },
                      ),
                      const SizedBox(
                          height: 20), // Add space between image and text
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      Text("Author:  ${book.author}"),
                      Text("Genre:  ${book.genre}"),
                      Text(
                        book.description,
                        textAlign: TextAlign.justify,
                      ),
                      Text(book.publishDate),

                      if (File(book.pdfFile!).existsSync())
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PdfViewerPage(pdfPath: book.pdfFile!)));
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" fill-rule="evenodd" d="M4.727 2.712c.306-.299.734-.494 1.544-.6C7.105 2.002 8.209 2 9.793 2h4.414c1.584 0 2.688.002 3.522.112c.81.106 1.238.301 1.544.6c.305.3.504.72.613 1.513c.112.817.114 1.899.114 3.45v7.839H7.346c-.903 0-1.519-.001-2.047.138c-.472.124-.91.326-1.299.592V7.676c0-1.552.002-2.634.114-3.451c.109-.793.308-1.213.613-1.513m2.86 3.072a.82.82 0 0 0-.828.81c0 .448.37.811.827.811h8.828a.82.82 0 0 0 .827-.81a.82.82 0 0 0-.827-.811zm-.828 4.594c0-.447.37-.81.827-.81h5.517a.82.82 0 0 1 .828.81a.82.82 0 0 1-.828.811H7.586a.82.82 0 0 1-.827-.81" clip-rule="evenodd"/><path fill="currentColor" d="M7.473 17.135c-1.079 0-1.456.007-1.746.083a2.46 2.46 0 0 0-1.697 1.538q.023.571.084 1.019c.109.793.308 1.213.613 1.513c.306.299.734.494 1.544.6c.834.11 1.938.112 3.522.112h4.414c1.584 0 2.688-.002 3.522-.111c.81-.107 1.238-.302 1.544-.601c.216-.213.38-.486.495-.91H7.586a.82.82 0 0 1-.827-.81c0-.448.37-.811.827-.811H19.97c.02-.466.027-1 .03-1.622z"/></svg>',
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "View PDF",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Row(
                children: [
                  SvgPicture.string(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" d="M7 4a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2h4a1 1 0 1 1 0 2h-1.069l-.867 12.142A2 2 0 0 1 17.069 22H6.93a2 2 0 0 1-1.995-1.858L4.07 8H3a1 1 0 0 1 0-2h4zm2 2h6V4H9zM6.074 8l.857 12H17.07l.857-12zM10 10a1 1 0 0 1 1 1v6a1 1 0 1 1-2 0v-6a1 1 0 0 1 1-1m4 0a1 1 0 0 1 1 1v6a1 1 0 1 1-2 0v-6a1 1 0 0 1 1-1"/></svg>',
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              onPressed: () {
                showModal(context, book);
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
          content: const Text("Are you sure you want to delete the book?"),
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
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AppDrawer()));
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
