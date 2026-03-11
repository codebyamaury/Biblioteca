import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_helper.dart';

class BookFormScreen extends StatefulWidget {
  final Book? book; // Si es null es CREATE, si tiene data es UPDATE

  BookFormScreen({this.book});

  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title, author, isbn;
  late int pages;

  @override
  void initState() {
    super.initState();
    title = widget.book?.title ?? '';
    author = widget.book?.author ?? '';
    isbn = widget.book?.isbn ?? '';
    pages = widget.book?.pages ?? 0;
  }

  void saveBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final book = Book(
        id: widget.book?.id,
        title: title,
        author: author,
        isbn: isbn,
        pages: pages,
      );

      if (widget.book == null) {
        await DatabaseHelper.instance.create(book); // Crear
      } else {
        await DatabaseHelper.instance.update(book); // Actualizar
      }

      Navigator.pop(context); // Regresa a la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.book == null ? 'Nuevo Libro' : 'Editar Libro', 
                    style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: DefaultTextStyle(
            style: const TextStyle(color: Color(0xFF1E293B)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]
                      ),
                      child: const Icon(Icons.my_library_books, size: 40, color: Color(0xFFD97706)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text('Información del Libro', 
                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: title,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Título del libro',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (val) => val!.isEmpty ? 'Falta el título' : null,
                    onSaved: (val) => title = val!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: author,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Autor',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (val) => val!.isEmpty ? 'Falta el autor' : null,
                    onSaved: (val) => author = val!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: isbn,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Código ISBN',
                      prefixIcon: Icon(Icons.qr_code),
                    ),
                    onSaved: (val) => isbn = val ?? '',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: pages == 0 ? '' : pages.toString(),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Número de páginas',
                      prefixIcon: Icon(Icons.layers_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => pages = int.tryParse(val ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: saveBook,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('GUARDAR LIBRO', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
