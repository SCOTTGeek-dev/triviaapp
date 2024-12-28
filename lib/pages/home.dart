import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triviaapp/pages/service.dart';
import 'dart:math';

class Home extends StatefulWidget {
  final String username;

  const Home({Key? key, required this.username}) : super(key: key);

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
    // Use the passed username or fallback
    participantName = widget.username;
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
          title: const Text("Enter Your Name"),
          content: TextField(
            onChanged: (value) {
              participantName = value.isEmpty ? widget.username : value;
            },
            decoration: InputDecoration(
              hintText: participantName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startCountdown();
              },
              child: const Text("Start Quiz"),
            ),
          ],
        );
      },
    );
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    timelineTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        await generateOptions();
      }
      setState(() {});
    }
  }

  Future<void> generateOptions() async {
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

    // Shuffle the options to randomize the correct answer position
    option.shuffle();

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

    Timer(const Duration(seconds: 2), () {
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
      participantName = widget.username;
      countdownSeconds = 3;
      timelineSeconds = 30;
    });
    showParticipantNameDialog();
  }

  void showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Quiz Result"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Participant: $participantName",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Time Spent: ${stopwatch.elapsed.inSeconds} seconds",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Score: $score out of 10",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Text(
                      "$correctAnswers",
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red,
                    child: Text(
                      "$wrongAnswers",
                      style: const TextStyle(fontSize: 24, color: Colors.white),
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
              child: const Text("Restart Quiz"),
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
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 14, 0, 0),
                  ),
                ),
              )
            : option.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        buildHeader(),
                        const SizedBox(height: 20),
                        buildCategoryList(),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  question!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                LinearProgressIndicator(
                                  value: timelineSeconds / 100,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 5, 25, 41)),
                                ),
                                const SizedBox(height: 20),
                                // Vertical list of options
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: option.length,
                                    separatorBuilder: (context, index) => 
                                      const SizedBox(height: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Score",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "$score",
                style: const TextStyle(
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
              const Text(
                "Question",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "$questionCount/10",
                style: const TextStyle(
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
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 255, 0, 208) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
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
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: getButtonColor(),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            option,
            textAlign: TextAlign.center,
            style: const TextStyle(
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
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: resetQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A9BF4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.2),
            ),
            child: const Text(
              "Reset Quiz",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Cancel timers to prevent memory leaks
    countdownTimer?.cancel();
    timelineTimer?.cancel();
    super.dispose();
  }
}