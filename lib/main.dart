import 'package:clean_architecture_app/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:clean_architecture_app/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:clean_architecture_app/features/daily_news/presentation/pages/home/daily_news.dart';
import 'package:clean_architecture_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme/app_themes.dart';

Future<void> main() async {
  await initializedDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteArticlesBloc>(
        create: (context) => sl()..add(GetArticles()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DailyNews(),
          theme: theme(),
        ));
  }
}
