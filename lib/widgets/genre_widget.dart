import 'package:flutter/material.dart';
import 'package:readeth/config/app_resources.dart';
import 'package:readeth/config/genre_list.dart';

class GenreWidget extends StatefulWidget {
  GenreWidget({super.key});

  @override
  State<GenreWidget> createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  String selectedGenre = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genreList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChoiceChip(
                elevation: 0,
                backgroundColor: Colors.grey[900],
                side: BorderSide.none,
                shape: const StadiumBorder(),
                label: Text(
                  "All Genres",
                  style: TextStyle(
                      color:
                          selectedGenre == 'All' ? Colors.black : Colors.white),
                ),
                selected: selectedGenre == 'All',
                selectedColor: primaryColor,
                showCheckmark: false,
                onSelected: (value) {
                  setState(() {
                    selectedGenre = 'All';
                  });
                },
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              elevation: 0,
              backgroundColor: Colors.grey[900],
              side: BorderSide.none,
              shape: const StadiumBorder(),
              label: Text(
                genreList[index - 1],
                style: TextStyle(
                  color: selectedGenre == genreList[index - 1]
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              selected: selectedGenre == genreList[index - 1],
              selectedColor: primaryColor,
              showCheckmark: false,
              onSelected: (value) {
                setState(() {
                  selectedGenre = genreList[index - 1];
                });
              },
            ),
          );
        },
      ),
    );
  }
}
