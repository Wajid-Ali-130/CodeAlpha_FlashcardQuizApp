import 'package:flashcard_quiz_app/screens/add_flashcard_screen.dart';
import 'package:flashcard_quiz_app/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = Hive.box('flashcards');

  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QuizScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),

            onPressed: () {

              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme();

            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFlashcardScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search Flashcards...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box box, _) {
                List filteredCards = [];

                for (int i = 0; i < box.length; i++) {
                  final card = box.getAt(i);

                  if (card["question"].toLowerCase().contains(searchText)) {
                    filteredCards.add({"data": card, "originalIndex": i});
                  }
                }

                if (filteredCards.isEmpty) {
                  return const Center(child: Text("No Flashcards Found"));
                }

                return ListView.builder(
                  itemCount: filteredCards.length,
                  itemBuilder: (context, index) {
                    final card = filteredCards[index]["data"];
                    final originalIndex = filteredCards[index]["originalIndex"];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(card["question"]),
                        subtitle: Text(card["answer"]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddFlashcardScreen(
                                index: index,
                                flashcard: Map<String, dynamic>.from(card),
                              ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete Flashcard"),
                                  content: const Text(
                                    "Are you sure you want to delete this flashcard?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        box.deleteAt(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Flashcard Deleted"),
                              ),
                            );
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
