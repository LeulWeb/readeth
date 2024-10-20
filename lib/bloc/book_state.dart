import 'package:equatable/equatable.dart';
import 'package:readeth/models/book_model.dart';

abstract class BookState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {
  @override
  List<Object> get props => [];
}

class BookLoading extends BookState {
  @override
  List<Object> get props => [];
}

class BookLoaded extends BookState {
  BookLoaded(this.books);
  final List<BookModel> books;
  @override
  List<Object> get props => [books];
}

class BookError extends BookState {
  BookError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
