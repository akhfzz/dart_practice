import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;

// main function
void main() {
  runApp(MyApp());
}

// variable
const host = 'my-json-server.typicode.com';
const user = 'akhfzz';
const repo = 'api_flutter';

// class instance
class Mahasiswa {
  final int? nim;
  final String nama;
  final String prodi;
  final String gender;
  final int? angkatan;

  Mahasiswa(
      {required this.nim,
      required this.nama,
      required this.prodi,
      required this.gender,
      required this.angkatan});

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
        nim: json['NIM'],
        nama: json['nama'],
        prodi: json['prodi'],
        gender: json['gender'],
        angkatan: json['angkatan']);
  }

  Map<String, dynamic> toJson() {
    return {
      'NIM': nim,
      'nama': nama,
      'prodi': prodi,
      'gender': gender,
      'angkatan': angkatan
    };
  }
}

class Nilai {
  final int? nim;
  final String kode;
  final String nilai;

  Nilai({
    this.nim,
    required this.kode,
    required this.nilai,
  });

  factory Nilai.fromJson(Map<String, dynamic> json) {
    return Nilai(
      nim: json['NIM'],
      kode: json['kode'],
      nilai: json['nilai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NIM': nim,
      'kode': kode,
      'nilai': nilai,
    };
  }
}

class Matakuliah {
  final String nama;
  final String kode;
  final int? sks;

  Matakuliah({
    required this.kode,
    required this.nama,
    this.sks,
  });

  factory Matakuliah.fromJson(Map<String, dynamic> json) {
    return Matakuliah(
      kode: json['kode'],
      nama: json['nama_mk'],
      sks: json['sks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode': kode,
      'nama_mk': nama,
      'sks': sks,
    };
  }
}

// append data
Future<bool> appendMahasiswa(Mahasiswa mahasiswa) async {
//   const url = 'https://$host/$user/$repo/mahasiswa';
  const url = 'http://127.0.0.1:5000/mahasiswa';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(mahasiswa.toJson()),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    throw Exception("Gagal menambahkan data");
  }
}

Future<bool> appendNilai(Nilai nilai) async {
  const url = 'http://127.0.0.1:5000/nilai';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(nilai.toJson()),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    throw Exception("Gagal menambahkan data");
  }
}

Future<bool> appendMatakuliah(Matakuliah mk) async {
  const url = 'http://127.0.0.1:5000/matakuliah';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(mk.toJson()),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    throw Exception("Gagal menambahkan data");
  }
}

// fetch list to API
Future<List<Mahasiswa>> fetchMahasiswa() async {
  const url = 'http://127.0.0.1:5000/mahasiswa';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var result = convert.jsonDecode(response.body);
    return [for (var item in result) Mahasiswa.fromJson(item)];
  } else {
    throw Exception('Gagal memuat data mahasiswa');
  }
}

Future<List<Nilai>> fetchNilai() async {
  const url = 'http://127.0.0.1:5000/nilai';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var result = convert.jsonDecode(response.body);
    return [for (var item in result) Nilai.fromJson(item)];
  } else {
    throw Exception('Gagal memuat data nilai');
  }
}

Future<List<Matakuliah>> fetchMatkul() async {
  const url = 'http://127.0.0.1:5000/matakuliah';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var result = convert.jsonDecode(response.body);
    return [for (var item in result) Matakuliah.fromJson(item)];
  } else {
    throw Exception('Gagal memuat data matakuliah');
  }
}

// update data
Future<bool> updateMahasiswa(int? nim, Mahasiswa mahasiswa) async {
  final url = 'http://127.0.0.1:5000/mahasiswa/$nim';
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(mahasiswa.toJson()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Gagal update data");
  }
}

Future<bool> updateNilai(Nilai nilai) async {
  const url = 'http://127.0.0.1:5000/nilai';
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(nilai.toJson()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Gagal update data");
  }
}

Future<bool> updateMatakuliah(String kode, Matakuliah mk) async {
  final url = 'http://127.0.0.1:5000/matakuliah/$kode';
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(mk.toJson()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Gagal update data");
  }
}

// delete data
Future<bool> deleteMahasiswa(int? nim) async {
  final url = 'http://127.0.0.1:5000/mahasiswa/$nim';
  final response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Gagal menghapus data");
  }
}

Future<bool> deleteNilai(String kode) async {
  final url = 'http://127.0.0.1:5000/nilai/mk/$kode';
  final response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Gagal menghapus data");
  }
}

Future<bool> deleteMatkul(String kode) async {
  final url = 'http://127.0.0.1:5000/matakuliah/$kode';
  final response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Gagal menghapus data");
  }
}

// frame
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
      routes: {
        ListMahasiswa.route: (context) => ListMahasiswa(),
        ListNilai.route: (context) => ListNilai(),
        ListMatakuliah.route: (context) => ListMatakuliah(),
        InputMahasiswa.route: (context) => InputMahasiswa(),
        InputNilai.route: (context) => InputNilai(),
        InputMatakuliah.route: (context) => InputMatakuliah()
      },
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  State createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List _screens = [ListMahasiswa(), ListNilai(), ListMatakuliah()];

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          currentIndex: _currentIndex,
          onTap: _updateIndex,
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
              label: "Mahasiswa",
              icon: Icon(Icons.person),
            ),
            BottomNavigationBarItem(
              label: "Nilai",
              icon: Icon(Icons.task),
            ),
            BottomNavigationBarItem(
              label: "Matakuliah",
              icon: Icon(Icons.collections),
            )
          ]),
    );
  }
}

class ListMahasiswa extends StatefulWidget {
  static const String route = '/mahasiswa';

  @override
  State createState() => ListMahasiswaState();
}

class ListMahasiswaState extends State<ListMahasiswa> {
  late Future<List<Mahasiswa>> _mhs;

  @override
  void initState() {
    super.initState();
    _mhs = fetchMahasiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Mahasiswa")),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: FutureBuilder<List<Mahasiswa>>(
              future: _mhs,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        '${snapshot.error}'.replaceFirst('Exception: ', '')),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(children: [
                  for (var stud in snapshot.data!.asMap().entries)
                    ListTile(
                        contentPadding: const EdgeInsets.all(10.0),
                        leading: Text('${stud.value.nim}'),
                        title:
                            Text('${stud.value.prodi} ${stud.value.angkatan}'),
                        subtitle: Text(stud.value.nama),
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            InputMahasiswa.route,
                            arguments: stud.value,
                          ) as Mahasiswa;
                          setState(() {
                            updateMahasiswa(stud.value.nim, result);
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            deleteMahasiswa(stud.value.nim);
                          });
                        })
                ]);
              })),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var req = await Navigator.pushNamed(
              context,
              InputMahasiswa.route,
            ) as Mahasiswa;
            setState(() {
              appendMahasiswa(req);
            });
          }),
    );
  }
}

class ListNilai extends StatefulWidget {
  static const String route = '/nilai';

  @override
  State createState() => ListNilaiState();
}

class ListNilaiState extends State<ListNilai> {
  late Future<List<Nilai>> _nilai;

  @override
  void initState() {
    super.initState();
    _nilai = fetchNilai();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Nilai")),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: FutureBuilder<List<Nilai>>(
              future: _nilai,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        '${snapshot.error}'.replaceFirst('Exception: ', '')),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(children: [
                  for (var val in snapshot.data!.asMap().entries)
                    ListTile(
                        contentPadding: const EdgeInsets.all(10.0),
                        leading: Text(val.value.kode),
                        title: Text('${val.value.nim}'),
                        subtitle: Text('NILAI: ${val.value.nilai}'),
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                              context, InputNilai.route,
                              arguments: val.value) as Nilai;
                          setState(() {
                            updateNilai(result);
                          });
                        },
                        onLongPress: () async {
                          setState(() {
                            deleteNilai(val.value.kode);
                          });
                        }),
                ]);
              })),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var req = await Navigator.pushNamed(
              context,
              InputNilai.route,
            ) as Nilai;
            setState(() {
              appendNilai(req);
            });
          }),
    );
  }
}

class ListMatakuliah extends StatefulWidget {
  static const String route = '/matkul';

  @override
  State createState() => ListMatakuliahState();
}

class ListMatakuliahState extends State<ListMatakuliah> {
  late Future<List<Matakuliah>> _matkul;

  @override
  void initState() {
    super.initState();
    _matkul = fetchMatkul();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Matakuliah")),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: FutureBuilder<List<Matakuliah>>(
              future: _matkul,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        '${snapshot.error}'.replaceFirst('Exception: ', '')),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(children: [
                  for (var val in snapshot.data!.asMap().entries)
                    ListTile(
                      contentPadding: const EdgeInsets.all(10.0),
                      leading: Text(val.value.kode),
                      title: Text(val.value.nama),
                      subtitle: Text('SKS: ${val.value.sks}'),
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                            context, InputMatakuliah.route,
                            arguments: val.value) as Matakuliah;
                        setState(() {
                          updateMatakuliah(val.value.kode, result);
                        });
                      },
                      onLongPress: () async {
                        setState(() {
                          deleteMatkul(val.value.kode);
                        });
                      },
                    )
                ]);
              })),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var req = await Navigator.pushNamed(
              context,
              InputMatakuliah.route,
            ) as Matakuliah;
            setState(() {
              appendMatakuliah(req);
            });
          }),
    );
  }
}

class InputMahasiswa extends StatefulWidget {
  static const String route = '/form-mhs';

  @override
  State createState() => InputMahasiswaState();
}

class InputMahasiswaState extends State<InputMahasiswa> {
  final formKey = GlobalKey<FormState>();

  final nimController = TextEditingController();
  final namaController = TextEditingController();
  final prodiController = TextEditingController();
  final angkatanController = TextEditingController();
  final genderController = TextEditingController();

  @override
  void dispose() {
    nimController.dispose();
    namaController.dispose();
    prodiController.dispose();
    angkatanController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Mahasiswa?;
    String action = args == null ? 'Tambah' : 'Edit';
    if (args != null) {
      nimController.text = args.nim.toString();
      namaController.text = args.nama;
      prodiController.text = args.prodi;
      angkatanController.text = args.angkatan.toString();
      genderController.text = args.gender;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('$action Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  hintText: 'NIM Mahasiswa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIM tak boleh kosong';
                  }
                  if (int.parse(value) < 100) {
                    return 'NIM tidak boleh dibawah angka 1000';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  hintText: 'Nama Mahasiswa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Mahasiswa tak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: prodiController,
                decoration: const InputDecoration(
                  hintText: 'Prodi Mahasiswa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prodi tidak boleh kosong';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: angkatanController,
                decoration: const InputDecoration(
                  hintText: 'Angkatan Mahasiswa',
                ),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.parse(value) < 0) {
                    return 'Angkatan Mahasiswa tidak boleh negatif';
                  }
                  if (value != null &&
                      value.isNotEmpty &&
                      int.parse(value) < 2000) {
                    return 'Angkatan Mahasiswa dibawah 2000 tidak tercantum';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(
                  hintText: 'Gender Mahasiswa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gender Mahasiswa tak boleh kosong';
                  }
                  if (value != "L" && value != "P") {
                    return "Masukkan gender dengan benar";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          var valid = formKey.currentState!.validate();
          if (!valid) return;
          Navigator.pop(
            context,
            Mahasiswa(
                nim: int.parse(nimController.text),
                nama: namaController.text,
                prodi: prodiController.text,
                angkatan: int.parse(angkatanController.text),
                gender: genderController.text),
          );
        },
      ),
    );
  }
}

class InputNilai extends StatefulWidget {
  static const String route = '/form-nilai';

  @override
  State createState() => InputNilaiState();
}

class InputNilaiState extends State<InputNilai> {
  final formKey = GlobalKey<FormState>();

  final nimController = TextEditingController();
  final kodeController = TextEditingController();
  final nilaiController = TextEditingController();

  @override
  void dispose() {
    nimController.dispose();
    kodeController.dispose();
    nilaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Nilai?;
    String action = args == null ? 'Tambah' : 'Edit';
    if (args != null) {
      nimController.text = args.nim.toString();
      kodeController.text = args.kode;
      nilaiController.text = args.nilai;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('$action Nilai'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  hintText: 'NIM Mahasiswa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIM tak boleh kosong';
                  }
                  if (int.parse(value) < 100) {
                    return 'NIM tidak boleh dibawah angka 1000';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: kodeController,
                decoration: const InputDecoration(
                  hintText: 'Kode matakuliah',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode Matakuliah tak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nilaiController,
                decoration: const InputDecoration(
                  hintText: 'Nilai Mahasiswa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai tidak boleh kosong';
                  }
                  if (value != "A" &&
                      value != "B" &&
                      value != "C" &&
                      value != "D") {
                    return 'Nilai melebihi range';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          var valid = formKey.currentState!.validate();
          if (!valid) return;
          Navigator.pop(
            context,
            Nilai(
              nim: int.parse(nimController.text),
              kode: kodeController.text,
              nilai: nilaiController.text,
            ),
          );
        },
      ),
    );
  }
}

class InputMatakuliah extends StatefulWidget {
  static const String route = '/form-mk';

  @override
  State createState() => InputMatakuliahState();
}

class InputMatakuliahState extends State<InputMatakuliah> {
  final formKey = GlobalKey<FormState>();

  final kodeController = TextEditingController();
  final namaController = TextEditingController();
  final sksController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    kodeController.dispose();
    sksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Matakuliah?;
    String action = args == null ? 'Tambah' : 'Edit';
    if (args != null) {
      namaController.text = args.nama.toString();
      kodeController.text = args.kode;
      sksController.text = args.sks.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('$action Nilai'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: kodeController,
                decoration: const InputDecoration(
                  hintText: 'Kode Matakuliah',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode matkul tak boleh kosong';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  hintText: 'Nama matakuliah',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Matakuliah tak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: sksController,
                decoration: const InputDecoration(
                  hintText: 'SKS Mahasiswa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'SKS tidak boleh kosong';
                  }
                  if (int.parse(value) < 0 || int.parse(value) > 4) {
                    return 'SKS melebihi range';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          var valid = formKey.currentState!.validate();
          if (!valid) return;
          Navigator.pop(
            context,
            Matakuliah(
              kode: kodeController.text,
              nama: namaController.text,
              sks: int.parse(sksController.text),
            ),
          );
        },
      ),
    );
  }
}
