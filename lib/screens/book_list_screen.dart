import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_helper.dart';
import 'book_form_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> booksFuture;

  @override
  void initState() {
    super.initState();
    refreshBooks();
  }

  void refreshBooks() {
    setState(() {
      booksFuture = DatabaseHelper.instance.readAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Mi Biblioteca', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: FutureBuilder<List<Book>>(
        future: booksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final books = snapshot.data!;
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No hay libros guardados', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text('Toca el botón + para agregar uno', style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 80),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.book, color: Color(0xFF1E293B)),
                    ),
                    title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book.author, style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.layers_outlined, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text('${book.pages} págs', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              const SizedBox(width: 12),
                              if (book.isbn.isNotEmpty) ...[
                                Icon(Icons.qr_code_2, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(book.isbn, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookFormScreen(book: book)),
                          );
                          refreshBooks();
                        } else if (value == 'delete') {
                          await DatabaseHelper.instance.delete(book.id!);
                          refreshBooks();
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit, color: Colors.blue),
                            title: Text('Editar'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Eliminar'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFD97706),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Libro', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookFormScreen()),
          );
          refreshBooks();
        },
      ),
    );
  }
}
