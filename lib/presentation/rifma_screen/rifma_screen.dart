import 'package:diplom/generated/l10n.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localeString = S.of(context);
    final backgroundColor =
        isDark ? const Color(0xFF2a213a) : const Color(0xffdea7db);
    final containerColor = isDark ? const Color(0xFF3a2f4c) : Colors.white;
    final inputFillColor =
        isDark ? const Color(0xFF5a4f70) : const Color(0xffdfd0f2);
    final overlayBackgroundColor = Colors.black.withValues(
      alpha: isDark ? 0.6 : 0.4,
    );
    final filterBoxColor = isDark ? const Color(0xFF4b4161) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleTextColor = isDark ? Colors.grey[400] : Colors.grey;
    final iconColor = isDark ? Colors.deepPurple[200] : Colors.deepPurple;
    final buttonColor =
        isDark
            ? const Color.fromARGB(181, 214, 58, 235)
            : const Color.fromARGB(181, 214, 58, 235);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                          color: containerColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 9),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller,
                          onSubmitted: _submit,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            hintText: localeString.enter_text,
                            hintStyle: TextStyle(
                              color: textColor.withValues(alpha: 0.6),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            prefixIcon: Icon(Icons.search, color: iconColor),
                            filled: true,
                            fillColor: inputFillColor,
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
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: containerColor,
                            child: Icon(
                              Icons.category_rounded,
                              color: iconColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!_anyFilterSelected() || controller.text.isEmpty)
                      Text(
                        localeString.choose_the_cur_filter,
                        style: TextStyle(color: textColor),
                      ),
                    if (state is DataMuseLoading ||
                        state is DataMuseRhymeLoading ||
                        state is DataMuseSynonymLoading ||
                        state is DataMuseAntonymLoading)
                      const CircularProgressIndicator(),
                    if (rhymeWords.isNotEmpty && showRhyme)
                      _buildFilterBox(
                        localeString.rhyme,
                        rhymeWords,
                        filterBoxColor,
                        textColor,
                        subtitleTextColor,
                        iconColor,
                      ),
                    if (synonymWords.isNotEmpty && showSynonym)
                      _buildFilterBox(
                        localeString.synonym,
                        synonymWords,
                        filterBoxColor,
                        textColor,
                        subtitleTextColor,
                        iconColor,
                      ),
                    if (antonymWords.isNotEmpty && showAntonym)
                      _buildFilterBox(
                        localeString.antonym,
                        antonymWords,
                        filterBoxColor,
                        textColor,
                        subtitleTextColor,
                        iconColor,
                      ),
                    if (similarWords.isNotEmpty && showSimilar)
                      _buildFilterBox(
                        localeString.similar_word,
                        similarWords,
                        filterBoxColor,
                        textColor,
                        subtitleTextColor,
                        iconColor,
                      ),
                  ],
                ),
                if (_showOverlay)
                  GestureDetector(
                    onTap: _toggleOverlay,
                    child: Container(color: overlayBackgroundColor),
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
                          color:
                              isDark
                                  ? const Color(0xFF61377B)
                                  : const Color(0xFFE399ED),
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
                            Text(
                              localeString.filter,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildCheckboxTile(
                              localeString.similar_word,
                              showSimilar,
                              (val) => setState(() => showSimilar = val!),
                              textColor,
                            ),
                            _buildCheckboxTile(
                              localeString.rhyme,
                              showRhyme,
                              (val) => setState(() => showRhyme = val!),
                              textColor,
                            ),
                            _buildCheckboxTile(
                              localeString.synonym,
                              showSynonym,
                              (val) => setState(() => showSynonym = val!),
                              textColor,
                            ),
                            _buildCheckboxTile(
                              localeString.antonym,
                              showAntonym,
                              (val) => setState(() => showAntonym = val!),
                              textColor,
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
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
                                  'Принять',
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

  Widget _buildFilterBox(
    String title,
    List<dynamic> words,
    Color bgColor,
    Color titleColor,
    Color? subtitleColor,
    Color? iconColor,
  ) {
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
          color: bgColor,
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
            Icon(Icons.label_important_outline, color: iconColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            const Spacer(),
            Text(
              "${words.length} слов",
              style: TextStyle(color: subtitleColor),
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
    Color textColor,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: TextStyle(color: textColor)),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
