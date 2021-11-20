// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cats Facts',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map? getResponse;
  String? dataResponse;
  int? dataLength;

  Future catsApi() async {
    http.Response response;
    response = await http.get(Uri.parse("https://catfact.ninja/fact"));
    if (response.statusCode == 200) {
      setState(() {
        getResponse = jsonDecode(response.body);
        dataResponse = getResponse!['fact'];
        dataLength = getResponse!['length'];

        print("data is below");
        print(getResponse);
        print(dataResponse);
        print(dataLength);
      });
    }
  }

  @override
  void initState() {
    catsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cat Facts"),
      ),
      body: RefreshIndicator(
        onRefresh: catsApi,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: Image.network(
                        "https://source.unsplash.com/480x480/?cats,meme",
                      ).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // child: Image.network(
                  //   'https://source.unsplash.com/480x480/?cats,meme',
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber[50],
                ),
                child: Center(
                  child: dataResponse == null
                      ? const Text("Fact's is Loading...")
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "$dataResponse",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Container(
              color: Colors.amber[50],
              child: Center(
                child: dataLength == null
                    ? const Text("Length is Loading...")
                    : Text("Words Length: $dataLength"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
