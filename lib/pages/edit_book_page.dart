import 'package:flutter/material.dart';
import 'package:readeth/bloc/book_bloc.dart';
import 'package:readeth/bloc/book_event.dart';
import 'package:readeth/bloc/book_state.dart';
import 'package:readeth/config/genre_list.dart';
import 'package:readeth/models/book_model.dart';
import 'package:readeth/pages/book_detail_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readeth/utils/show_toast.dart';

class EditBookPage extends StatefulWidget {
  final BookModel book;
  const EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String author = '';
  String description = '';
  String publishDate = '';
  String selectedGenre = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      title = widget.book.title;
      author = widget.book.author;
      description = widget.book.description;
      publishDate = widget.book.publishDate;
      selectedGenre = widget.book.genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Removed Expanded here, ListView already takes up available space
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: title,
                    decoration: const InputDecoration(
                      labelText: "Book Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter title';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        title = value.trim(); // Fixed assignment
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    value: selectedGenre,
                    decoration: const InputDecoration(
                      labelText: "Genre",
                    ),
                    items: genreList.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGenre = value as String;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: author,
                    decoration: const InputDecoration(
                      labelText: "Author",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Author name is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        author = value.trim(); // Fixed assignment
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: description,
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter description';
                      }
                      return null;
                    },
                    maxLines: 3,
                    onChanged: (value) {
                      setState(() {
                        description = value.trim(); // Fixed assignment
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<BookBloc, BookState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: state is BookLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final book = BookModel(
                                    id: widget.book.id,
                                    title: title,
                                    author: author,
                                    genre: selectedGenre,
                                    description: description,
                                    publishDate: publishDate,
                                  );
                                  context
                                      .read<BookBloc>()
                                      .add(UpdateBookEvent(book));

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailPage(book: book)));
                                  // show snack bar message
                                  showScaffoldSnackBar(context,
                                      "${book.title} is updated", Colors.green);
                                }
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFFF279),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: state is BookLoading
                              ? const Text(
                                  "Loading ...",
                                  style: TextStyle(color: Colors.black),
                                )
                              : const Text(
                                  "Update Book",
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
