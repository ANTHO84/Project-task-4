import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<int> playedSounds = [];
  Timer? replayTimer;
  final player = AudioPlayer();  // Create a single AudioPlayer instance

  Future<void> playSound(int soundNumber) async {
    try {
      await player.play(AssetSource('note$soundNumber.wav'));
      setState(() {
        playedSounds.add(soundNumber);
      });
      startReplayTimer();  // Reset the timer every time a sound is played
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void startReplayTimer() {
    replayTimer?.cancel();  // Cancel any existing timer
    replayTimer = Timer(Duration(seconds: 3), replaySounds);
  }

  Future<void> replaySounds() async {
    for (int soundNumber in playedSounds) {
      await player.play(AssetSource('note$soundNumber.wav'));
      await Future.delayed(Duration(milliseconds: 500));  // Delay between sounds
    }
  }
  Expanded buildKey({required Color color, required int soundNumber}) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        onPressed: () {
          playSound(soundNumber);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$soundNumber',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
              ),
            ),
            if (playedSounds.contains(soundNumber))
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20.0,
                ),
                
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildKey(color: Colors.red, soundNumber: 1),
              buildKey(color: Colors.orange, soundNumber: 2),
              buildKey(color: Colors.yellow, soundNumber: 3),
              buildKey(color: Colors.green, soundNumber: 4),
              buildKey(color: Colors.teal, soundNumber: 5),
              buildKey(color: Colors.blue, soundNumber: 6),
              buildKey(color: Colors.purple, soundNumber: 7),
            ],
          ),
        ),
      ),
    );
  }
}
