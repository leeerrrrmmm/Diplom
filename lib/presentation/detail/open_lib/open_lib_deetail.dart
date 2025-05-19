import 'package:diplom/domain/entity/open_lib/open_lib.dart';
import 'package:diplom/generated/l10n.dart';
import 'package:diplom/presentation/service/bloc/open_lib_bloc/open_lib_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenLibDeetail extends StatelessWidget {
  final OpenLibEntity curBook;
  const OpenLibDeetail({super.key, required this.curBook});

  @override
  Widget build(BuildContext context) {
    final localString = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localString.detail_book),
        backgroundColor: const Color(0xff9a73cb),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff9a73cb), Color(0xFFdfd0f2)],
          ),
        ),
        child: BlocBuilder<OpenLibBloc, OpenLibState>(
          builder: (context, state) {
            if (state.isBookLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.selectedBook != null) {
              final book = state.selectedBook!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    curBook.coverUrl != null
                        ? Image.network(curBook.coverUrl!)
                        : Image.asset('assets/flut.png'),
                    const SizedBox(height: 20),

                    // Название книги
                    Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Автор
                    Text(
                      '${localString.author}: ${curBook.author}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Описание
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        localString.description,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      book.description ?? 'Описание недоступно.',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox(
                child: const Center(child: Text('Не удалось загрузить книгу.')),
              );
            }
          },
        ),
      ),
    );
  }
}
