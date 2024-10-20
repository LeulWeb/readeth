import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:readeth/bloc/book_bloc.dart';
import 'package:readeth/bloc/book_event.dart';
import 'package:readeth/bloc/book_state.dart';
import 'package:readeth/config/genre_list.dart';
import 'package:readeth/models/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readeth/utils/show_toast.dart';
import 'package:readeth/widgets/app_drawer.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String author = '';
  String description = '';
  String publishDate = '';
  String selectedGenre = 'Miscellaneous';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration: const InputDecoration(
                      labelText: "Genre",
                    ),
                    value: selectedGenre,
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
                                    title: title,
                                    author: author,
                                    description: description,
                                    publishDate: publishDate,
                                    genre: selectedGenre,
                                  );

                                  Logger().d(book.toString());
                                  context
                                      .read<BookBloc>()
                                      .add(AddBookEvent(book));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AppDrawer()));
                                  // show snack bar message
                                  showScaffoldSnackBar(context,
                                      "${book.title} is added", Colors.green);
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
                                  "Loading...",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  "Save Book",
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
