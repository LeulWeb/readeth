import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:readeth/bloc/book_bloc.dart';
import 'package:readeth/bloc/book_state.dart';
import 'package:readeth/pages/book_detail_page.dart';

import 'package:readeth/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoaded) {
                  return GridView.builder(
                    itemCount: state.books.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailPage(book: state.books[index])));
                        },
                        child: GridTile(
                          child: Column(
                            children: [
                              Image.network(
                                  "https://m.media-amazon.com/images/I/71OVB8HknWL._AC_UF1000,1000_QL80_.jpg"),
                              Text(state.books[index].title),
                              Text(state.books[index].id.toString()),
                              Text(state.books[index].author)
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is BookLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookError) {
                  return const Center(child: Text("Error loading books"));
                } else {
                  return const Center(child: Text("No books available"));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
