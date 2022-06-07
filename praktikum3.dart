import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
//       home: MainRoute(),
      initialRoute: '/',
      routes: {
        '/': (context) => MainRoute(),
        '/other': (context) => OtherRoute()
      },
    );
  }
}

class MainRoute extends StatefulWidget {
  @override
  State createState() => MainRouteState();
}

class OtherArguments {
  final int counter;
  OtherArguments(this.counter);
}

class MainRouteState extends State<MainRoute> {
  int _counter = 0;
  void incRoute() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
      ),
      body: Center(
        child: Text(
          'Konten Halaman Utama',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: () async {
          incRoute();
          bool result = await Navigator.pushNamed(
            context,
            '/other',
            arguments: OtherArguments(_counter),
          ) as bool;
          if (result) {
            setState(() {
              _counter = 0;
            });
          }
        },
      ),
    );
  }
}

class OtherRoute extends StatelessWidget {
//   final int counter;
//   const OtherRoute(this.counter);
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OtherArguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Lainnya'),
      ),
      body: Center(
          child: Column(children: [
        Text(
          'Konten Halaman Lainnya, ${args.counter}',
          style: Theme.of(context).textTheme.headline4,
        ),
        ElevatedButton(
            child: const Text("Reset"),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ])),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
