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
      initialRoute: '/',
      routes: {
        HomeRoute.routeName: (context) => HomeRoute(),
        ViewRoute.routeName: (context) => ViewRoute(),
      },
    );
  }
}

class HomeRoute extends StatelessWidget {
  static String routeName = '/';
  final fnController = TextEditingController();
  final lnController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mencoba Widget Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: fnController,
                decoration: const InputDecoration(
                  hintText: 'Nama depan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama depan harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lnController,
                decoration: const InputDecoration(
                  hintText: 'Nama belakang',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Tampilkan'),
                onPressed: () {
                  bool isValid = formKey.currentState!.validate();
                  if (!isValid) return;
                  Navigator.pushNamed(
                    context,
                    ViewRoute.routeName,
                    arguments: ViewArguments(
                      firstName: fnController.text,
                      lastName: lnController.text,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewArguments {
  final String firstName;
  final String? lastName;

  ViewArguments({
    required this.firstName,
    this.lastName,
  });
}

class ViewRoute extends StatelessWidget {
  static String routeName = '/view';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ViewArguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menampilkan Data Input'),
      ),
      body: Center(
        child: Text(
          '${args.firstName} ${args.lastName}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
