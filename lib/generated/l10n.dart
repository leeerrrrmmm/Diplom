// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Choose Language`
  String get locale {
    return Intl.message('Choose Language', name: 'locale', desc: '', args: []);
  }

  /// `Enter text..`
  String get enter_text {
    return Intl.message('Enter text..', name: 'enter_text', desc: '', args: []);
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Select the Language`
  String get select_lang {
    return Intl.message(
      'Select the Language',
      name: 'select_lang',
      desc: '',
      args: [],
    );
  }

  /// `Select the category`
  String get select_category {
    return Intl.message(
      'Select the category',
      name: 'select_category',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Dark theme`
  String get dark {
    return Intl.message('Dark theme', name: 'dark', desc: '', args: []);
  }

  /// `Light Theme`
  String get light {
    return Intl.message('Light Theme', name: 'light', desc: '', args: []);
  }

  /// `Enter the search term`
  String get term {
    return Intl.message(
      'Enter the search term',
      name: 'term',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get author {
    return Intl.message('Author', name: 'author', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Choose the correct filter and add some query`
  String get choose_the_cur_filter {
    return Intl.message(
      'Choose the correct filter and add some query',
      name: 'choose_the_cur_filter',
      desc: '',
      args: [],
    );
  }

  /// `Rhyme`
  String get rhyme {
    return Intl.message('Rhyme', name: 'rhyme', desc: '', args: []);
  }

  /// `Synonym`
  String get synonym {
    return Intl.message('Synonym', name: 'synonym', desc: '', args: []);
  }

  /// `Antonym`
  String get antonym {
    return Intl.message('Antonym', name: 'antonym', desc: '', args: []);
  }

  /// `Similar words`
  String get similar_word {
    return Intl.message(
      'Similar words',
      name: 'similar_word',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'uk'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
