import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:readeth/pages/book_detail_page.dart';
import 'package:readeth/services/database_service.dart';
import 'package:readeth/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService.instance;
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: AppDrawer(),
      body: Column(
        children: [
          Expanded(
            // Only this Expanded is needed here
            child: FutureBuilder(
              future: _databaseService.getBooks(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  Logger().e(snapshot.error.toString());
                  return const Center(child: Text("Error loading books"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No books available"));
                } else {
                  return GridView.builder(
                    itemCount: snapshot.data?.length ?? 0,
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
                                  BookDetailPage(book: snapshot.data![index])));
                        },
                        child: GridTile(
                          child: Column(
                            children: [
                              Image.network(
                                  "https://www.designforwriters.com/wp-content/uploads/2017/10/design-for-writers-book-cover-tf-2-a-million-to-one.jpg"),
                              Text(snapshot.data![index].title),
                              Text(snapshot.data![index].author)
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
