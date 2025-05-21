import 'package:diplom/generated/l10n.dart';
import 'package:diplom/presentation/service/bloc/wiki_bloc/wiki_bloc.dart';
import 'package:diplom/presentation/service/common/lang/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WikiPage extends StatefulWidget {
  const WikiPage({super.key});

  @override
  State<WikiPage> createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localeString = S.of(context);
    final localeCode =
        Provider.of<LocaleProvider>(
          context,
          listen: false,
        ).locale!.languageCode;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Цвета в зависимости от темы
    final backgroundColor =
        isDark ? const Color(0xFF1E1E2C) : const Color(0xFFF3EFFF);
    final inputFillColor =
        isDark ? const Color(0xFF2E2E3E) : const Color(0xFFE6DDF3);
    final inputTextColor = isDark ? Colors.white : Colors.black;
    final boxShadowColor =
        isDark ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.2);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 10.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: inputFillColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: boxShadowColor,
                        blurRadius: 8,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: inputTextColor),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.read<WikiBloc>().add(
                          FetchWiki(term: value, language: localeCode),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: localeString.enter_text,
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
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
                      prefixIcon: Icon(Icons.search, color: inputTextColor),
                      filled: true,
                      fillColor: inputFillColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<WikiBloc, WikiState>(
                  builder: (context, state) {
                    if (state is WikiLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WikiLoaded) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (state.summary.imageUrl != null)
                              Image.network(
                                state.summary.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Text(
                                state.summary.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Text(
                              state.summary.extract,
                              style: TextStyle(fontSize: 18, color: textColor),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      );
                    } else if (state is WikiError) {
                      return Center(
                        child: Text(
                          state.errorMsg,
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        localeString.term,
                        style: TextStyle(color: textColor),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
