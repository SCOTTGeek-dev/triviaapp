import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triviaapp/pages/service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool music = true,
      geography = false,
      fooddrinks = false,
      sciencenature = false,
      entertainment = false;

  String? question, answer;
  List<String> option = [];

  @override
void initState() {
  super.initState();
  option = []; // Reset options first
  RestOption().then((_) {
    fetchQuiz("music"); // Fetch quiz after options are loaded
  });
}

  //API integration//
  Future<void> fetchQuiz(String category) async {
    final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/trivia?category=$category'),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': APIKEY,
        });

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        Map<String, dynamic> quiz = jsonData[0];
        question = quiz["question"];
        answer = quiz["answer"];
      }
      setState(() {});
    }
  }

  Future<void> RestOption() async {
    if (option.length >= 3)
      return; // Add this line to prevent infinite recursion

    final response = await http
        .get(Uri.parse('https://api.api-ninjas.com/v1/randomword'), headers: {
      'Content-Type': 'application/json',
      'X-Api-Key': APIKEY,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      String word = jsonData["word"].toString();
      option.add(word);

      if (option.length < 3) {
        await RestOption(); // Use await here
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: option.length != 3
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Stack(
                children: [
                  // Background image
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "images/background.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Top horizontal list of categories
                  Container(
                    margin: const EdgeInsets.only(top: 70.0, left: 20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              music
                                  ? Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 120,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 237, 146, 9),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: const Center(
                                            child: Text(
                                              "Music",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        music = true;
                                        geography = false;
                                        fooddrinks = false;
                                        entertainment = false;
                                        sciencenature = false;
                                        option = [];
                                        await RestOption();
                                        await fetchQuiz("music");
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 120,
                                        margin:
                                            const EdgeInsets.only(right: 20.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Center(
                                          child: Text(
                                            "Music",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              geography
                                  ? Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 140,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 237, 146, 9),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: const Center(
                                            child: Text(
                                              "Geography",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async{
                                          music = false;
                                          geography = true;
                                          fooddrinks = false;
                                          entertainment = false;
                                          sciencenature = false;
                                          option = [];
                                          await RestOption();
                                          await fetchQuiz("geography");
                                        setState((){});
                                      },
                                      child: Container(
                                        width: 140,
                                        margin:
                                            const EdgeInsets.only(right: 20.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Center(
                                          child: Text(
                                            "Geography",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              fooddrinks
                                  ? Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 237, 146, 9),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: const Center(
                                            child: Text(
                                              "FoodDrinks",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async{
                                          music = false;
                                          geography = false;
                                          fooddrinks = true;
                                          entertainment = false;
                                          sciencenature = false;
                                          option = [];
                                          await RestOption();
                                          await fetchQuiz("fooddrinks");
                                           setState(() {});
                                      },
                                      child: Container(
                                        width: 150,
                                        margin:
                                            const EdgeInsets.only(right: 20.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Center(
                                          child: Text(
                                            "FoodDrinks",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              sciencenature
                                  ? Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 237, 146, 9),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: const Center(
                                            child: Text(
                                              "Science & Nature",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async{
                                          music = false;
                                          geography = false;
                                          fooddrinks = false;
                                          entertainment = false;
                                          sciencenature = true;
                                          option = [];
                                          await RestOption();
                                          await fetchQuiz("sciencenature");
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 200,
                                        margin:
                                            const EdgeInsets.only(right: 20.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Center(
                                          child: Text(
                                            "Science & Nature",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              entertainment
                                  ? Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 170,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 237, 146, 9),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: const Center(
                                            child: Text(
                                              "Entertainment",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async{
                                          music = false;
                                          geography = false;
                                          fooddrinks = false;
                                          entertainment = true;
                                          sciencenature = false;
                                           option = [];
                                          await RestOption();
                                          await fetchQuiz("entertainment");
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width, //to fix//
                                        margin:
                                            const EdgeInsets.only(right: 20.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Center(
                                          child: Text(
                                            "Entertainment",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                  // White container with updated style
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.18,
                    left: 20.0,
                    right: 20.0,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Text(
                              question!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            height: 60,
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black45, width: 2.0),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                option[0].replaceAll(RegExp(r'[\[\]]'),
                                    ""), // Correct positional parameters
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            height: 60,
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black45, width: 2.0),
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: Text(
                                "Albert Einstein",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            height: 60,
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black45, width: 2.0),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                option[1].replaceAll(RegExp(r'[\[\]]'), ""),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            height: 60,
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black45, width: 2.0),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                option[2].replaceAll(RegExp(r'[\[\]]'), ""),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
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
