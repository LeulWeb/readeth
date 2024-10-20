import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:readeth/models/book_model.dart';
import 'package:readeth/services/database_service.dart';

class EditBookPage extends StatefulWidget {
  final BookModel book;
  const EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService.instance;

  String title = '';
  String author = '';
  String description = '';
  String publishDate = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      title = widget.book.title;
      author = widget.book.author;
      description = widget.book.description;
      publishDate = widget.book.publishDate;
    });
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      final book = BookModel(
        id: widget.book.id,
        title: title,
        author: author,
        description: description,
        publishDate: publishDate,
      );
      Logger().d({
        "id": widget.book.id,
        "title": title,
        "author": author,
        "description": description,
        "publishDate": publishDate,
      });
      _databaseService.updateBook(book);
    }
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
                  GestureDetector(
                    onTap: _saveBook,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFFF279),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: const Text(
                        "Update Book",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
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
