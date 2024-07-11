import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'classroom_activities.dart';
import 'main.dart';
import 'profile.dart';
import 'dart:convert';

class ClassScreen extends StatelessWidget {
  const ClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'icons/eiems-logo.png',
                    height: 40.0,
                  ),
                  const SizedBox(width: 15.0),
                  const Text(
                    'EIEMS',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF383838),
                      fontFamily: 'KronaOne',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_rounded),
              title: const Text('Manage Class'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClassScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6CBCFB),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        elevation: 20.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: _buildRows(data, context),
                ),
              );
            }
            return const Text("No data");
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/poc_head/poc/fetch_poc.php'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<Widget> _buildRows(List<Map<String, dynamic>> data, BuildContext context) {
    List<Widget> rows = [];
    for (int i = 0; i < data.length; i += 3) {
      List<Widget> rowItems = [];
      for (int j = i; j < i + 3 && j < data.length; j++) {
        rowItems.add(
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClassroomActivityScreen(),
                  ),
                );
              },
              child: ContainerItem(data: data[j]),
            ),
          ),
        );
      }
      rows.add(Row(children: rowItems));
    }
    return rows;
  }
}

class ContainerItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const ContainerItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Elevated Container
            Container(
              width: 450,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            // Image with Text Overlay
            Positioned(
              bottom: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.asset(
                      'icons/bg-mobile-1.png',
                      width: 450,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Text(
                        data['subject'] ?? 'No Subject',
                        style: const TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 45,
                      child: Text(
                        data['subject_code'] ?? 'No Code',
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 60,
                      child: Text(
                        data['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
