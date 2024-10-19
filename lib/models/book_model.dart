class BookModel {
  final String title;
  final String author;
  final String description;
  final String publishDate;

  BookModel({
    required this.title,
    required this.author,
    required this.description,
    required this.publishDate,
  });

  // Factory method to handle potential null values
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      title: map['title'] as String? ??
          '', // Provide fallback empty string if null
      author: map['author'] as String? ?? '', // Fallback empty string
      description: map['description'] as String? ?? '', // Fallback empty string
      publishDate: map['publishDate'] as String? ?? '', // Fallback empty string
    );
  }
}
