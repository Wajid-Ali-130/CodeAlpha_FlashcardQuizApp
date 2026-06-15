import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  final box = Hive.box('flashcards');

  int currentIndex = 0;

  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {

    if(box.isEmpty){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz Mode"),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(
                Icons.menu_book,
                size: 80,
                color: Colors.grey,
              ),

              SizedBox(height: 15),

              Text(
                "No Flashcards Yet",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "Press + to add flashcards",
              ),

            ],
          ),
        ),
      );
    }

    final card = box.getAt(currentIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Mode"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Card(
              elevation: 5,

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),

                child: Column(

                  children: [

                    Text(
                      card["question"],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 25),

                    if(showAnswer)
                      Text(
                        card["answer"],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  showAnswer = !showAnswer;
                });
              },

              child: Text(
                showAnswer
                    ? "Hide Answer"
                    : "Show Answer",
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,

              children: [

                ElevatedButton(
                  onPressed: currentIndex > 0
                      ? () {

                    setState(() {
                      currentIndex--;
                      showAnswer = false;
                    });

                  }
                      : null,

                  child: const Text("Previous"),
                ),

                ElevatedButton(
                  onPressed: currentIndex <
                      box.length - 1
                      ? () {

                    setState(() {
                      currentIndex++;
                      showAnswer = false;
                    });

                  }
                      : null,

                  child: const Text("Next"),
                ),

              ],
            ),

            const SizedBox(height: 20),

            Text(
              "${currentIndex + 1} / ${box.length}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}