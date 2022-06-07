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
        initialRoute: ListRoute.routeName,
        routes: {
          ListRoute.routeName: (context) => ListRoute(),
          AddRoute.routeName: (context) => AddRoute(),
        });
  }
}

class Product {
  final String code;
  final String name;
  final double price;
  final int? stock;

  Product({
    required this.code,
    required this.name,
    required this.price,
    this.stock,
  });
}

class ListRoute extends StatefulWidget {
  static const String routeName = '/';

  @override
  State createState() => ListRouteState();
}

class ListRouteState extends State<ListRoute> {
  final _items = [
    Product(code: 'A001', name: 'Pepsodent', price: 10000, stock: 100),
    Product(code: 'A002', name: 'Lifebuoy', price: 3500),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            for (Product item in _items)
              ListTile(
                title: Text(item.name),
                subtitle: Text(item.code),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AddRoute.routeName,
          ) as Product;
          setState(() {
            _items.add(result);
          });
        },
      ),
    );
  }
}

class AddRoute extends StatelessWidget {
  static const String routeName = '/add';

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  hintText: 'Kode Produk',
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Nama Produk',
                ),
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: 'Harga Satuan',
                ),
              ),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(
                  hintText: 'Banyaknya Stok',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          Navigator.pop(
            context,
            Product(
              code: codeController.text,
              name: nameController.text,
              price: double.parse(priceController.text),
              stock: int.parse(stockController.text),
            ),
          );
        },
      ),
    );
  }
}
