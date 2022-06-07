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
  final _items = <Product>[];

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
            for (var item in _items.asMap().entries)
              ListTile(
                title: Text(item.value.name),
                subtitle: Text('${item.value.code}, ${item.value.stock} item'),
                onTap: () async {
                  int idx = item.key;
                  final result = await Navigator.pushNamed(
                    context,
                    AddRoute.routeName,
                    arguments: item.value,
                  ) as Product;
                  setState(() {
                    _items[idx] = result;
                  });
                },
                onLongPress: () {
                  int idx = item.key;
                  setState(() {
                    _items.removeAt(idx);
                  });
                },
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
    final args = ModalRoute.of(context)!.settings.arguments as Product?;
    String action = args == null ? 'Tambah' : 'Edit';
    if (args != null) {
      codeController.text = args.code;
      nameController.text = args.name;
      priceController.text = args.price.toString();
      stockController.text = args.stock.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('$action Produk'),
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
