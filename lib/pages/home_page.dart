import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
          const Text("Hello there"),
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
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data![index].title),
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
