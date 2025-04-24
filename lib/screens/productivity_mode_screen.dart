import 'dart:async';
import 'package:flutter/material.dart';

class ProductivityModeScreen extends StatefulWidget {
  final Function(int) onCoinsEarned;

  const ProductivityModeScreen({super.key, required this.onCoinsEarned});

  @override
  ProductivityModeScreenState createState() => ProductivityModeScreenState();
}

class ProductivityModeScreenState extends State<ProductivityModeScreen> {
  int selectedTime = 5;
  int remainingTime = 0;
  Timer? timer;
  bool isProductivityActive = false;
  //starts the timer
  void startTimer() {
    setState(() {
      remainingTime = selectedTime * 60; //converts the selected time into seconds
      isProductivityActive = true;
    });
    //creates a repeating timer
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime <= 0) {
        endProductivityMode();
      } else {
        setState(() {
          remainingTime--;
        });

        if (remainingTime % 300 == 0) { //every 5 minutes
          widget.onCoinsEarned(50);
        }
      }
    });
  }

  void endProductivityMode() {
    timer?.cancel();
    setState(() {
      isProductivityActive = false;
    });
    Navigator.pop(context); //exit the screen
  }

  //to ensure the timer is deleted once exited screen
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //builds productivity screen ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: isProductivityActive
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Stay Focused!',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              '${(remainingTime ~/ 60).toString().padLeft(2, '0')}:${(remainingTime % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 48, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: endProductivityMode,
              child: const Text('Exit Productivity Mode'),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Time for Productivity Mode:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              value: selectedTime,
              dropdownColor: Colors.black87,
              style: const TextStyle(color: Colors.white),
              items: [5, 10, 15, 20, 25, 30].map((e) => DropdownMenuItem(value: e, child: Text('$e minutes'))).toList(),
              onChanged: (value) {setState(() {selectedTime = value!;});
              }
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: startTimer, child: const Text('Start Focus Session'))
          ]
        )
      )
    );
  }
}


