import 'package:readeth/models/book_model.dart';

abstract class BookEvent {}



class AddBookEvent extends BookEvent {
  AddBookEvent(this.book);
  final BookModel book;
}

class UpdateBookEvent extends BookEvent {
  UpdateBookEvent(this.book);
  final BookModel book;
}

class DeleteBookEvent extends BookEvent {
  DeleteBookEvent(this.book);
  final BookModel book;
}


class GetBooksEvent extends BookEvent {
  final String genre;
  GetBooksEvent(this.genre);
}