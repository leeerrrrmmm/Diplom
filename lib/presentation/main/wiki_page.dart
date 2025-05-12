import 'package:diplom/presentation/service/bloc/wiki_bloc/wiki_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WikiPage extends StatefulWidget {
  const WikiPage({super.key});

  @override
  State<WikiPage> createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb9a7de),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: "Enter a term...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<WikiBloc>().add(FetchWiki(term: value));
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<WikiBloc, WikiState>(
                  builder: (context, state) {
                    if (state is WikiLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is WikiLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (state.summary.imageUrl != null)
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(
                                      state.summary.imageUrl!,
                                    ),
                                  ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      bottom: 24,
                                      top: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xffdfd0f2),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(60),
                                        topLeft: Radius.circular(60),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.summary.title,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                            top: 10,
                                          ),
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            state.summary.extract,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xffdfd0f2),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60),
                                  topRight: Radius.circular(60),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'There is a lot of information here.',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is WikiError) {
                      return Center(child: Text(state.errorMsg));
                    }
                    return Center(child: Text("Введите термин для поиска"));
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
