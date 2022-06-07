import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
          InputRoute.routeName: (context) => InputRoute(),
        });
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final int? stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }
}

const host = 'my-json-server.typicode.com';
const user = 'ochiwansa';
const repo = 'fake_api';

Future<List<Product>> fetchProducts() async {
  const url = 'https://$host/$user/$repo/products';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var result = convert.jsonDecode(response.body);
    return [for (var item in result) Product.fromJson(item)];
  } else {
    throw Exception('Gagal memuat daftar produk');
  }
}

Future<bool> appendProduct(Product product) async {
  const url = 'https://$host/$user/$repo/products';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(product.toJson()),
  );
  return (response.statusCode == 201);
}

Future<bool> updateProduct(String id, Product product) async {
  final url = 'https://$host/$user/$repo/products/$id';
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(product.toJson()),
  );
  return (response.statusCode == 200);
}

// buat function deleteProduct
Future<bool> deleteProduct(String id) async {
  final url = 'https://$host/$user/$repo/products/$id';
  final response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{'Content-Type': 'application/json'},
  );
  return (response.statusCode == 200);
}

class ListRoute extends StatefulWidget {
  static const String routeName = '/';

  @override
  State createState() => ListRouteState();
}

class ListRouteState extends State<ListRoute> {
  late Future<List<Product>> _items;

  @override
  void initState() {
    super.initState();
    _items = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Product>>(
          future: _items,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child:
                    Text('${snapshot.error}'.replaceFirst('Exception: ', '')),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: [
                for (var item in snapshot.data!.asMap().entries)
                  ListTile(
                    title: Text(item.value.name),
                    subtitle:
                        Text('${item.value.id}, ${item.value.stock} item'),
                    onTap: () async {
                      int idx = item.key;
                      final result = await Navigator.pushNamed(
                        context,
                        InputRoute.routeName,
                        arguments: item.value,
                      ) as Product;
                      // kode untuk update ke API
                      bool req = await updateProduct(item.value.id, result);
                      if (req) {
                        setState(() {
                          snapshot.data![idx] = result;
                        });
                      }
                    },
                    onLongPress: () async {
                      int idx = item.key;
                      // kode untuk menghapus data di API
                      var req = await deleteProduct(item.value.id);
                      if (req) {
                        setState(() {
                          snapshot.data!.removeAt(idx);
                        });
                      }
                    },
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final product = await Navigator.pushNamed(
            context,
            InputRoute.routeName,
          ) as Product;
          bool result = await appendProduct(product);
          if (result) {
            setState(() {
              _items.then((data) {
                data.add(product);
              });
            });
          } else {
            // tampilkan snackbar utk pesan kesalahan.
          }
        },
      ),
    );
  }
}

class InputRoute extends StatefulWidget {
  static const String routeName = '/input';

  @override
  State createState() => InputRouteState();
}

class InputRouteState extends State<InputRoute> {
  final formKey = GlobalKey<FormState>();

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Product?;
    String action = args == null ? 'Tambah' : 'Edit';
    if (args != null) {
      codeController.text = args.id;
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
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  hintText: 'Kode Produk',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode produk tak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Nama Produk',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: 'Harga Satuan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tak boleh kosong';
                  }
                  if (int.parse(value) < 100) {
                    return 'Harga tak boleh kurang dari 100 rupiah';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(
                  hintText: 'Banyaknya Stok',
                ),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.parse(value) < 0) {
                    return 'Stok tidak boleh negatif';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Navigator.pop(
              context,
              Product(
                id: codeController.text,
                name: nameController.text,
                price: double.parse(priceController.text),
                stock: int.parse(stockController.text),
              ),
            );
          }
        },
      ),
    );
  }
}
