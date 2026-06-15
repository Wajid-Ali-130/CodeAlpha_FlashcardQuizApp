import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddFlashcardScreen extends StatefulWidget {

  final int? index;
  final Map? flashcard;
  const AddFlashcardScreen({super.key, this.index, this.flashcard});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  //................................................
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  final box = Hive.box('flashcards');
  //................................................

  @override
  void initState(){
    super.initState();

    if(widget.flashcard != null){
      questionController.text = widget.flashcard!['question'];

      answerController.text = widget.flashcard!['answer'];
    }
  }

  void saveCard() {
    if(questionController.text.trim().isEmpty ||
        answerController.text.trim().isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Flashcard Saved Successfully"),
        ),
      );
    }

      if(widget.index == null){

        // Add New Card

        box.add({
          "question": questionController.text,
          "answer": answerController.text,
        });

      } else {

        // Update Existing Card

        box.putAt(
          widget.index!,
          {
            "question": questionController.text,
            "answer": answerController.text,
          },
        );
      }

      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Flashcards')),
      body: Padding(
          padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 30,),
            FloatingActionButton(onPressed: saveCard,
            child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
