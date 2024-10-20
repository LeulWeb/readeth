class BookModel {
  final int? id;
  final String title;
  final String genre;
  final String author;
  String? coverImage;
  final String description;
  final String publishDate;
  String? pdfFile;

  BookModel({
    this.id,
    this.genre = 'Miscellaneous',
    this.coverImage,
    required this.title,
    required this.author,
    required this.description,
    required this.publishDate,
    this.pdfFile,
  });

  // Factory method to handle potential null values
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ??
          '', // Provide fallback empty string if null
      author: map['author'] as String? ?? '', // Fallback empty string
      coverImage: map['cover_image'] ?? '', // Fallback empty string
      pdfFile: map['pdf_file'] ?? '', // Fallback empty string
      genre:
          map['genre'] as String? ?? 'Miscellaneous', // Fallback empty string

      description: map['description'] as String? ?? '', // Fallback empty string
      publishDate: map['publishDate'] as String? ?? '', // Fallback empty string
    );
  }

  //to string
  @override
  String toString() {
    return 'BookModel{id: $id, title: $title, genre: $genre, author: $author, coverImage: $coverImage, description: $description, publishDate: $publishDate, pdfFile: $pdfFile}';
  }
}
