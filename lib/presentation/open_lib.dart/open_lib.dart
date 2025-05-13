import 'dart:developer';

import 'package:diplom/generated/l10n.dart';
import 'package:diplom/presentation/detail/open_lib/open_lib_deetail.dart';
import 'package:diplom/presentation/service/bloc/open_lib_bloc/open_lib_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenLib extends StatefulWidget {
  const OpenLib({super.key});
  @override
  State<OpenLib> createState() => _OpenLibState();
}

class _OpenLibState extends State<OpenLib> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    context.read<OpenLibBloc>().add(LoadInitialBooks());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<OpenLibBloc>().add(LoadMoreBooks());
      }
    });

    // Инициализация анимации
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.5, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
      if (_showOverlay) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeString = S.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xff9a73cb), Color(0xFFdfd0f2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: Offset(0, 9), // смещение тени
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (query) {
                      context.read<OpenLibBloc>().add(SearchBooks(query));
                    },
                    decoration: InputDecoration(
                      hintText: localeString.enter_text,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Color(0xffdfd0f2), // важно для тени
                    ),
                  ),
                ),
              ),
              // Иконка для анимации
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: _toggleOverlay,
                  child: const CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.category_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Список книг и другие виджеты
              Expanded(
                child: BlocBuilder<OpenLibBloc, OpenLibState>(
                  builder: (context, state) {
                    if (state.isLoading && state.books.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.books.length + 1,
                      itemBuilder: (context, index) {
                        if (index < state.books.length) {
                          final book = state.books[index];
                          return GestureDetector(
                            onTap: () {
                              context.read<OpenLibBloc>().add(
                                FetchBookDetailEvent(book.bookKey),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OpenLibDeetail(curBook: book),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffdfd0f2),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                left: 14,
                                bottom: 20,
                              ),
                              width: 415,
                              height: 188,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 120,
                                    height: 188,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      image:
                                          book.coverUrl != null
                                              ? DecorationImage(
                                                image: NetworkImage(
                                                  book.coverUrl!,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                              : DecorationImage(
                                                image: AssetImage(
                                                  'assets/flut.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              book.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${localeString.author}: ${book.author}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return state.isLoading
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : SizedBox();
                        }
                      },
                    );
                  },
                ),
              ),
              // Here, move the overlay code inside the widget tree
              if (_showOverlay) ...[
                GestureDetector(
                  onTap: _toggleOverlay,
                  child: AnimatedOpacity(
                    opacity: _showOverlay ? 0.6 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(color: Colors.black),
                  ),
                ),
                Center(
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Container(
                      margin: const EdgeInsets.all(34),
                      width: 385,
                      height: 574,

                      decoration: BoxDecoration(
                        color: Color(0xffcaa7de),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Фильтры',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xff9b1dba),
                                child: Icon(
                                  Icons.translate,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                'Выбор языка',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          //lan
                          ElevatedButton(
                            onPressed: () => log('En'),
                            child: const Text('En'),
                          ),

                          ElevatedButton(
                            onPressed: () => log('Uk'),
                            child: const Text('Uk'),
                          ),
                          ElevatedButton(
                            onPressed: () => log('Ru'),
                            child: const Text('Ru'),
                          ),
                          const SizedBox(height: 24),
                          // CATEGORY
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xff9b1dba),
                                child: Icon(
                                  Icons.line_style_sharp,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                'Выбор категории',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => log('Фантастика'),
                                    child: const Text('Фантастика'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => log('Фантастика'),
                                    child: const Text('Фантастика'),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => log('Фантастика'),
                                    child: const Text('Фантастика'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => log('Фантастика'),
                                    child: const Text('Фантастика'),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => log('Фантастика'),
                                    child: const Text('Фантастика'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => log('Фантастика'),
                                    child: const Text('Фантастика'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
