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
    final localeCode =
        Provider.of<LocaleProvider>(
          context,
          listen: false,
        ).locale!.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xffb9a7de),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
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
                    controller: _controller,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.read<WikiBloc>().add(
                          FetchWiki(term: value, language: localeCode),
                        );
                      }
                    },
                    decoration: InputDecoration(
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
                      fillColor: Color(0xffdfd0f2), // важно для тени
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Text(
                              state.summary.extract,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      );
                    } else if (state is WikiError) {
                      return Center(child: Text(state.errorMsg));
                    }
                    return const Center(
                      child: Text("Введите термин для поиска"),
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
