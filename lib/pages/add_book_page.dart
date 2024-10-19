import 'package:flutter/material.dart';
import 'package:readeth/models/book_model.dart';
import 'package:readeth/services/database_service.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService.instance;

  String title = '';
  String author = '';
  String description = '';
  String publishDate = '';

  @override
  void initState() {
    super.initState();
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      final book = BookModel(
        title: title,
        author: author,
        description: description,
        publishDate: publishDate,
      );
      _databaseService.addBook(book);
    }
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
                  GestureDetector(
                    onTap: _saveBook,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: const Text(
                        "Save Book",
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
