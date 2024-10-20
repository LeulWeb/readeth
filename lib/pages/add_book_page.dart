import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readeth/bloc/book_bloc.dart';
import 'package:readeth/bloc/book_event.dart';
import 'package:readeth/bloc/book_state.dart';
import 'package:readeth/config/genre_list.dart';
import 'package:readeth/models/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readeth/utils/show_toast.dart';
import 'package:readeth/widgets/app_drawer.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';


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
  String coverImagePath = '';
  String pdfFilePath = ''; // Variable for storing PDF file path

  File? _imageFile;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imageFile = savedImage; // Store the picked image file
        coverImagePath = savedImage.path;
      });
      Logger().d(
          'Image saved at: ${savedImage.path}'); // This path will be saved in SQLite
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pdfFilePath = result.files.single.path!; // Store the PDF file path
      });
      Logger().d('PDF selected at: $pdfFilePath'); // Log the path for debugging
    }
  }

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
                        title = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                        author = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
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
                        description = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_imageFile != null)
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_rounded),
                        onPressed: () async {
                          await _pickImage();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickPdf,
                    child: const Text('Upload PDF'),
                  ),
                  if (pdfFilePath.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Selected PDF: ${basename(pdfFilePath)}'),
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
                                    title: title,
                                    author: author,
                                    description: description,
                                    publishDate: publishDate,
                                    genre: selectedGenre,
                                    coverImage: coverImagePath,
                                    pdfFile: pdfFilePath, // Add this line
                                  );

                                  Logger().e(book.toString());
                                  context
                                      .read<BookBloc>()
                                      .add(AddBookEvent(book));

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => AppDrawer()));

                                  showScaffoldSnackBar(context,
                                      "${book.title} is added", Colors.green);
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
