import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          HomeRoute.routeName: (context) => HomeRoute(),
          ViewRoute.routeName: (context) => ViewRoute(),
        });
  }
}

class HomeRoute extends StatelessWidget {
  static String routeName = '/';
  final fnController = TextEditingController();
  final lnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trying Form Widget"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextFormField(
              controller: fnController,
              decoration: const InputDecoration(hintText: "First Name"),
            ),
            TextFormField(
              controller: lnController,
              decoration: const InputDecoration(hintText: "Last Name"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                child: const Text("Show"),
                onPressed: () {
                  final firstName = fnController.text;
                  final lastName = lnController.text;
                  Navigator.pushNamed(context, ViewRoute.routeName,
                      arguments: ViewArguments(
                          firstName: fnController.text,
                          lastName: lnController.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$firstName $lastName'),
                    ),
                  );
                }),
          ]),
        ),
      ),
    );
  }
}

class ViewArguments {
  final String firstName;
  final String? lastName;
  ViewArguments({required this.firstName, this.lastName});
}

class ViewRoute extends StatelessWidget {
  static String routeName = '/view';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ViewArguments;
    return Scaffold(
      appBar: AppBar(title: const Text("Show Input Data")),
      body: Center(
        child: Text('${args.firstName} ${args.lastName}',
            style: Theme.of(context).textTheme.headline4),
      ),
    );
  }
}
