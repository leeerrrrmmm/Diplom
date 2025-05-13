import 'package:diplom/presentation/detail/rhyme_detail/rhyme_detail.dart';
import 'package:diplom/presentation/service/bloc/data_muse_bloc/data_muse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RifmaScreen extends StatefulWidget {
  const RifmaScreen({super.key});

  @override
  State<RifmaScreen> createState() => _RifmaScreenState();
}

class _RifmaScreenState extends State<RifmaScreen>
    with SingleTickerProviderStateMixin {
  final controller = TextEditingController();

  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  bool _showOverlay = false;

  bool showRhyme = false;
  bool showSynonym = false;
  bool showAntonym = false;
  bool showSimilar = false;

  List<dynamic> rhymeWords = [];
  List<dynamic> synonymWords = [];
  List<dynamic> antonymWords = [];
  List<dynamic> similarWords = [];

  @override
  void initState() {
    super.initState();

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
    controller.dispose();
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

  void _submit(String value) {
    final bloc = context.read<DataMuseBloc>();

    if (value.isEmpty || !_anyFilterSelected()) return;

    if (showRhyme) {
      bloc.add(SearchRhymeWords(rhymeQuery: value));
    }
    if (showSynonym) {
      bloc.add(SearchSynonymWords(synonymQuery: value));
    }
    if (showAntonym) {
      bloc.add(SearchAntonymWords(antonymQuery: value));
    }
    if (showSimilar) {
      bloc.add(SearchWords(query: value));
    }
  }

  bool _anyFilterSelected() =>
      showRhyme || showSynonym || showAntonym || showSimilar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdea7db),
      body: SafeArea(
        child: BlocConsumer<DataMuseBloc, DataMuseState>(
          listener: (context, state) {
            if (state is DataMuseRhymeLoaded) {
              rhymeWords = state.rhymeWords;
            } else if (state is DataMuseSynonymLoaded) {
              synonymWords = state.synonyms;
            } else if (state is DataMuseSAntonymLoaded) {
              antonymWords = state.antonyms;
            } else if (state is DataMuseLoaded) {
              similarWords = state.words;
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 9),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller,
                          onSubmitted: _submit,
                          decoration: const InputDecoration(
                            hintText: 'Введите текст',
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
                            fillColor: Color(0xffdfd0f2),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: _toggleOverlay,
                          child: const CircleAvatar(
                            radius: 24,
                            child: Icon(Icons.category_rounded),
                          ),
                        ),
                      ),
                    ),
                    if (!_anyFilterSelected() || controller.text.isEmpty)
                      const Text("Выберите фильтры и введите слово"),
                    if (state is DataMuseLoading ||
                        state is DataMuseRhymeLoading ||
                        state is DataMuseSynonymLoading ||
                        state is DataMuseAntonymLoading)
                      const CircularProgressIndicator(),
                    if (rhymeWords.isNotEmpty && showRhyme)
                      _buildFilterBox("Рифмы", rhymeWords),
                    if (synonymWords.isNotEmpty && showSynonym)
                      _buildFilterBox("Синонимы", synonymWords),
                    if (antonymWords.isNotEmpty && showAntonym)
                      _buildFilterBox("Антонимы", antonymWords),
                    if (similarWords.isNotEmpty && showSimilar)
                      _buildFilterBox("Похожие", similarWords),
                  ],
                ),
                if (_showOverlay)
                  GestureDetector(
                    onTap: _toggleOverlay,
                    child: Container(color: Colors.black.withOpacity(0.4)),
                  ),
                if (_showOverlay)
                  Center(
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Container(
                        margin: const EdgeInsets.all(34),
                        width: 385,
                        height: 574,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 227, 153, 237),
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
                              'Фильтры:',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildCheckboxTile(
                              "Похожие слова",
                              showSimilar,
                              (val) => setState(() => showSimilar = val!),
                            ),
                            _buildCheckboxTile(
                              "Рифмы",
                              showRhyme,
                              (val) => setState(() => showRhyme = val!),
                            ),
                            _buildCheckboxTile(
                              "Синонимы",
                              showSynonym,
                              (val) => setState(() => showSynonym = val!),
                            ),
                            _buildCheckboxTile(
                              "Антонимы",
                              showAntonym,
                              (val) => setState(() => showAntonym = val!),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    181,
                                    214,
                                    58,
                                    235,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  fixedSize: const Size(200, 60),
                                ),
                                onPressed: () {
                                  _toggleOverlay();
                                  _submit(controller.text.trim());
                                },
                                child: const Text(
                                  "Применить",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterBox(String title, List<dynamic> words) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailResultScreen(title: title, words: words),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.label_important_outline, color: Colors.deepPurple),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              "${words.length} слов",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
