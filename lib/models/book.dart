class Book {
  int? id;
  String title;
  String author;
  String isbn;
  int pages;

  Book({this.id, required this.title, required this.author, required this.isbn, required this.pages});

  // Convertimos un Libro en un Map para mandarlo a la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'pages': pages,
    };
  }

  // Convertimos un Map extraído de la BD a un objeto de tipo Libro.
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      isbn: map['isbn'],
      pages: map['pages'],
    );
  }
}
