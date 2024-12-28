import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triviaapp/pages/service.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key, required String username});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool music = true,
      geography = false,
      fooddrink = false,
      sciencenature = false,
      entertainment = false;

  String? question, answer;
  List<String> option = [];
  int? selectedOptionIndex;
  int score = 0;
  int questionCount = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  Stopwatch stopwatch = Stopwatch();
  String participantName = '';
  int countdownSeconds = 3;
  int timelineSeconds = 30;
  Timer? countdownTimer;
  Timer? timelineTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showParticipantNameDialog();
    });
  }

  void showParticipantNameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Your Name"),
          content: TextField(
            onChanged: (value) {
              participantName = value;
            },
            decoration: InputDecoration(hintText: "Participant Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startCountdown();
              },
              child: Text("Start Quiz"),
            ),
          ],
        );
      },
    );
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdownSeconds--;
      });
      if (countdownSeconds == 0) {
        countdownTimer?.cancel();
        fetchQuiz("music");
        startTimeline();
        stopwatch.start();
      }
    });
  }

  void startTimeline() {
    timelineTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timelineSeconds--;
      });
      if (timelineSeconds == 0) {
        timelineTimer?.cancel();
        checkAnswer(-1); // Automatically move to the next question
      }
    });
  }

  Future<void> fetchQuiz(String category) async {
    option = [];
    selectedOptionIndex = null;
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
        await RestOption();
      }
      setState(() {});
    }
  }

  Future<void> RestOption() async {
    while (option.length < 3) {
      final response = await http
          .get(Uri.parse('https://api.api-ninjas.com/v1/randomword'), headers: {
        'Content-Type': 'application/json',
        'X-Api-Key': APIKEY,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        String word = jsonData["word"].toString();
        option.add(word);
      }
    }

    final random = Random();
    final randomIndex = random.nextInt(option.length + 1);
    option.insert(randomIndex, answer!);

    setState(() {});
  }

  void checkAnswer(int index) {
    timelineTimer?.cancel();
    setState(() {
      selectedOptionIndex = index;
      if (index == -1) {
        wrongAnswers++;
      } else if (option[index] == answer) {
        score++;
        correctAnswers++;
      } else {
        wrongAnswers++;
      }
      questionCount++;
    });

    Timer(Duration(seconds: 2), () {
      if (questionCount < 10) {
        fetchQuiz(music
            ? "music"
            : geography
                ? "geography"
                : fooddrink
                    ? "fooddrink"
                    : sciencenature
                        ? "sciencenature"
                        : "entertainment");
        timelineSeconds = 100;
        startTimeline();
      } else {
        stopwatch.stop();
        showResult();
      }
    });
  }

  void resetQuiz() {
    setState(() {
      score = 0;
      questionCount = 0;
      correctAnswers = 0;
      wrongAnswers = 0;
      stopwatch.reset();
      participantName = '';
      countdownSeconds = 3;
      timelineSeconds = 100;
    });
    showParticipantNameDialog();
  }

  void showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz Result"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Participant: $participantName",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Time Spent: ${stopwatch.elapsed.inSeconds} seconds",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Score: $score out of 10",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Text(
                      "$correctAnswers",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red,
                    child: Text(
                      "$wrongAnswers",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetQuiz();
              },
              child: Text("Restart Quiz"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: countdownSeconds > 0
            ? Center(
                child: Text(
                  "$countdownSeconds",
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            : option.length != 4
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        buildHeader(),
                        SizedBox(height: 20),
                        buildCategoryList(),
                        SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  question!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                LinearProgressIndicator(
                                  value: timelineSeconds / 100,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: option.length,
                                    itemBuilder: (context, index) {
                                      return buildOptionButton(
                                        option: option[index]
                                            .replaceAll(RegExp(r'[\[\]]'), ""),
                                        index: index,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        buildFooter(),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Score",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "$score",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Question",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "$questionCount/10",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategoryList() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildCategoryButton("Music", music, () => selectCategory("music")),
          buildCategoryButton(
              "Geography", geography, () => selectCategory("geography")),
          buildCategoryButton(
              "FoodDrinks", fooddrink, () => selectCategory("fooddrink")),
          buildCategoryButton("Science & Nature", sciencenature,
              () => selectCategory("sciencenature")),
          buildCategoryButton("Entertainment", entertainment,
              () => selectCategory("entertainment")),
        ],
      ),
    );
  }

  Widget buildCategoryButton(
      String category, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6A9BF4) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void selectCategory(String category) {
    setState(() {
      music = category == "music";
      geography = category == "geography";
      fooddrink = category == "fooddrink";
      sciencenature = category == "sciencenature";
      entertainment = category == "entertainment";
    });
    fetchQuiz(category);
  }

  Widget buildOptionButton({required String option, required int index}) {
    final isSelected = selectedOptionIndex == index;
    final isCorrect = option == answer;

    Color getButtonColor() {
      if (isSelected) {
        return isCorrect ? Colors.green : Colors.red;
      }
      return Colors.grey.shade300;
    }

    return GestureDetector(
      onTap: () => checkAnswer(index),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: getButtonColor(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            option,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: resetQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6A9BF4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.2),
            ),
            child: Text(
              "Reset Quiz",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
