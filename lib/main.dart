import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const Running());
}

class Running extends StatelessWidget {
  const Running({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Forstate(),
    );
  }
}

class Forstate extends StatefulWidget {
  const Forstate({super.key});

  @override
  State<StatefulWidget> createState() {
    return Main();
  }
}

class Main extends State {
  static List? products;
  var count;
  var productsShow = List<String>.filled(20, 'HI');

  TextEditingController mycontroller = TextEditingController();

  fetchProductApi() async {
    var response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    products = jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: TextField(
            decoration: const InputDecoration(hintText: 'Search here..'),
            onChanged: (text) {
              setState(() {
                mycontroller.text = text;

                f2();
              });
            },
          ),
        ),
        body: FutureBuilder(
            future: fetchProductApi(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return GridView.builder(
                    itemCount:
                        (mycontroller.text == '' ? products?.length : count),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(
                              products?[index]['image']), 
                          fit: BoxFit.cover,
                        )),
                       // color: Colors.blueGrey,
                        child: GestureDetector(
                            onTap: () {},
                            child: Align(
                              alignment:Alignment.bottomCenter,
                              child: Text(
                                (mycontroller.text == ''
                                    ? '${products?[index]['title']}'
                                    : productsShow[index]),
                                style: const TextStyle(color: Color.fromARGB(255, 39, 249, 1)),
                              ),
                            )),
                      );
                    });
              }
            }));
  }

  f2() {
    count = 0;
    productsShow = List<String>.filled(20, '');
    for (var i = 0; i < products!.length; i++) {
      if (products?[i]['title'].contains(mycontroller.text)) {
        productsShow[count] = products?[i]['title'];
        count++;
      }
    }
  }
}
