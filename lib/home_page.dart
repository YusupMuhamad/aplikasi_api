import 'package:aplikasi_api/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> users = [];
  Map<String, String>? specificUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadSpecificUser();
  }

  Future<void> _loadData() async {
    var url = Uri.parse("https://reqres.in/api/users");
    var response = await http.get(url);
    var data = jsonDecode(response.body)['data'] as List;

    setState(() {
      users = data
          .map<Map<String, String>>((user) => {
                'id': user['id'].toString(),
                'first_name': user['first_name'],
                'last_name': user['last_name'],
                'avatar': user['avatar'],
                'email': user['email']
              })
          .toList();
      isLoading = false;
    });
  }

  Future<void> _loadSpecificUser() async {
    var url = Uri.parse("https://reqres.in/api/users/10");
    var response = await http.get(url);
    var data = jsonDecode(response.body)['data'];

    setState(() {
      specificUser = {
        'id': data['id'].toString(),
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'avatar': data['avatar'],
        'email': data['email']
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Warna baru untuk AppBar
        title: Text(widget.title),
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "SEMUA PENGGUNA",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.deepPurple), // Ukuran dan warna teks diubah
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Card(
                        // Menggunakan Card
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(users[index]['avatar']!),
                          ),
                          title: Text(
                              '${users[index]['first_name']} ${users[index]['last_name']}',
                              style: TextStyle(
                                  color: Colors.black87) // Warna teks diubah
                              ),
                          subtitle: Text('ID: ${users[index]['id']}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(user: users[index])),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (specificUser != null)
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "GET ID YANG DITENTUKAN",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(specificUser!['avatar']!),
                        ),
                        title: Text(
                            '${specificUser!['first_name']} ${specificUser!['last_name']}'),
                        subtitle: Text('ID: ${specificUser!['id']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(user: specificUser!)),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const TambahPengguna()),
      //     );
      //   },
      //   backgroundColor: Colors.green, // Warna baru untuk FloatingActionButton
      //   tooltip: 'Tambah Pengguna',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class UserListView extends StatelessWidget {
  final List<Map<String, String>> users;

  const UserListView({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(users[index]['avatar']!),
          ),
          title: Text(
              '${users[index]['first_name']} ${users[index]['last_name']}'),
          subtitle: Text('ID: ${users[index]['id']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(user: users[index])),
            );
          },
        );
      },
    );
  }
}
