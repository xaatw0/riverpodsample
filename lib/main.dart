import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  static const KEY = 'KEY';

  final _provider = FutureProvider<int>((ref) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(KEY) ?? 0;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            ref.watch(_provider).when(
                  data: (data) => Text(
                    '${ref.watch(_provider).value}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  loading: (data) => const CircularProgressIndicator(),
                  error: (error, stack, data) => Text('error'),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          int currentValue = prefs.getInt(KEY) ?? 0;
          prefs.setInt(KEY, currentValue + 1);
          ref.refresh(_provider);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
