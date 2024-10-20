import 'package:readeth/models/book_model.dart';

abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  BookLoaded(this.books);
  final List<BookModel> books;
}

class BookError extends BookState {
  BookError(this.error);
  final String error;
}