import 'package:flutter/material.dart';

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






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            // Background image
            SizedBox(
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
                                margin: const EdgeInsets.only(right: 20.0),
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
                                onTap: () {
                                  setState(() {
                                    music = true;
                                    geography = false;
                                    fooddrinks = false;
                                    entertainment = false;
                                    sciencenature = false;
                                  });
                                },
                                child: Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
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
                                margin: const EdgeInsets.only(right: 20.0),
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
                                onTap: () {
                                  setState(() {
                                    music = false;
                                    geography = true;
                                    fooddrinks = false;
                                    entertainment = false;
                                    sciencenature = false;
                                  });
                                },
                                child: Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
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
                                margin: const EdgeInsets.only(right: 20.0),
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
                                onTap: () {
                                  setState(() {
                                    music = false;
                                    geography = false;
                                    fooddrinks = true;
                                    entertainment = false;
                                    sciencenature = false;
                                  });
                                },
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
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
                                margin: const EdgeInsets.only(right: 20.0),
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
                                onTap: () {
                                  setState(() {
                                    music = false;
                                    geography = false;
                                    fooddrinks = false;
                                    entertainment = false;
                                    sciencenature = true;
                                  });
                                },
                                child: Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
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
                                margin: const EdgeInsets.only(right: 20.0),
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
                                onTap: () {
                                  setState(() {
                                    music = false;
                                    geography = false;
                                    fooddrinks = false;
                                    entertainment = true;
                                    sciencenature = false;
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
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
            SizedBox(
              height: 80.0,
            ),
            // White container with updated style
            Positioned(
              top: MediaQuery.of(context).size.height * 0.18,
              left: 20.0,
              right: 20.0,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
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
                      child: const Text(
                        "Who Was The Midnight Rider ?",
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
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                        child: Text(
                          "Bill Gates",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
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
                    SizedBox(height: 30.0,),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                        child: Text(
                          "Neil Armstrong",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                        child: Text(
                          "Paul Davidson",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
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
