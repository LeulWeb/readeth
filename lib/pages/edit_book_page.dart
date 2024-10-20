import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readeth/bloc/book_bloc.dart';
import 'package:readeth/bloc/book_event.dart';
import 'package:readeth/bloc/book_state.dart';
import 'package:readeth/config/genre_list.dart';
import 'package:readeth/models/book_model.dart';
import 'package:readeth/pages/book_detail_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readeth/utils/show_toast.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

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
  String? coverImagePath;
  String? pdfFilePath; // Add this variable to store the PDF file path

  File? _imageFile; // This will hold the new selected image
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Initialize form fields with data from the book model
    setState(() {
      title = widget.book.title;
      author = widget.book.author;
      description = widget.book.description;
      publishDate = widget.book.publishDate;
      selectedGenre = widget.book.genre;
      coverImagePath = widget.book.coverImage; // Original cover image
      pdfFilePath =
          widget.book.pdfFile; // Initialize with the original PDF path
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imageFile =
            savedImage; // Update the image file with the newly picked image
        coverImagePath = savedImage.path; // Update the cover image path
      });
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pdfFilePath = result.files.single.path!; // Store the new PDF file path
      });
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
                        title = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    value: selectedGenre.isEmpty ? null : selectedGenre,
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
                  const SizedBox(height: 20),
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
                        author = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
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
                        description = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Display the cover image
                  if (coverImagePath != null && coverImagePath!.isNotEmpty)
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _imageFile != null
                              ? FileImage(
                                  _imageFile!) // Display the new image if selected
                              : FileImage(File(
                                  coverImagePath!)), // Otherwise, display the original image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_rounded),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Button to upload a new PDF
                  ElevatedButton(
                    onPressed: _pickPdf,
                    child: const Text('Upload PDF'),
                  ),
                  if (pdfFilePath != null && pdfFilePath!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Selected PDF: ${basename(pdfFilePath!)}'),
                    ),
                  const SizedBox(height: 20),
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
                                    coverImage:
                                        coverImagePath, // Ensure this is set
                                    pdfFile:
                                        pdfFilePath, // Add the PDF file path here
                                  );
                                  context
                                      .read<BookBloc>()
                                      .add(UpdateBookEvent(book));

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailPage(book: book)));
                                  showScaffoldSnackBar(context,
                                      "${book.title} is updated", Colors.green);
                                }
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFFF279),
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
