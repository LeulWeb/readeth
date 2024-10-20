import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:readeth/bloc/book_event.dart';
import 'package:readeth/bloc/book_state.dart';
import 'package:readeth/models/book_model.dart';
import 'package:readeth/services/database_service.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(BookInitial()) {
    on<AddBookEvent>(addBook);
    on<UpdateBookEvent>(updateBook);
    on<DeleteBookEvent>(deleteBook);
    on<GetBooksEvent>(
      (event, emit) async {
        final DatabaseService _databaseService = DatabaseService.instance;
        emit(BookLoading());
        try {
          List<BookModel> books = await _databaseService.getBooks();
          emit(BookLoaded(books));
        } catch (e) {
          emit(BookError(e.toString()));
        }
      },
    );
  }

  void addBook(AddBookEvent event, Emitter<BookState> emit) async {
    final DatabaseService databaseService = DatabaseService.instance;

    emit(BookLoading());
    try {
      await databaseService.addBook(event.book);
      emit(BookLoaded(await databaseService.getBooks()));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  void updateBook(UpdateBookEvent event, Emitter<BookState> emit) async {
    final DatabaseService databaseService = DatabaseService.instance;
    emit(BookLoading());
    try {
      await databaseService.updateBook(event.book);
      emit(BookLoaded(await databaseService.getBooks()));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  void deleteBook(DeleteBookEvent event, Emitter<BookState> emit) async {
    final DatabaseService databaseService = DatabaseService.instance;
    emit(BookLoading());
    try {
      await databaseService.deleteBook(event.book.id!);
      emit(BookLoaded(await databaseService.getBooks()));
    } catch (e) {
      Logger().e(e.toString());
      emit(BookError(e.toString()));
    }
  }
}
