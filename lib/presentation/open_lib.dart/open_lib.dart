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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundGradient =
        isDark
            ? [Colors.black87, Colors.grey.shade900]
            : [const Color(0xff9a73cb), const Color(0xFFdfd0f2)];
    final containerColor = isDark ? Colors.grey.shade800 : Colors.white;
    final searchFillColor =
        isDark ? Colors.grey.shade700 : const Color(0xffdfd0f2);
    final bookItemColor =
        isDark ? Colors.grey.shade700 : const Color(0xffdfd0f2);
    final overlayColor =
        isDark ? Colors.grey.shade800 : const Color(0xffcaa7de);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 9),
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
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: searchFillColor,
                    ),
                  ),
                ),
              ),
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
              Expanded(
                child: BlocBuilder<OpenLibBloc, OpenLibState>(
                  builder: (context, state) {
                    if (state.isLoading && state.books.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
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
                                color: bookItemColor,
                                borderRadius: const BorderRadius.only(
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
                                      borderRadius: const BorderRadius.only(
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
                                              : const DecorationImage(
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
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${localeString.author}: ${book.author}',
                                              style: const TextStyle(
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
                              ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : const SizedBox();
                        }
                      },
                    );
                  },
                ),
              ),
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
                        color: overlayColor,
                        borderRadius: const BorderRadius.only(
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
                              const CircleAvatar(
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
                          Row(
                            children: [
                              const CircleAvatar(
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
                            children: List.generate(
                              3,
                              (_) => Row(
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
                            ),
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
