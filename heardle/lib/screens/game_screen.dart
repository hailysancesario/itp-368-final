import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../audio_player.dart';
import '../songs.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late String currentSongFilePath;
  int attempts = 0; // To track the number of guesses
  List<String> guesses = []; // To store guesses
  String currentGuess = ''; // Current input guess
  Duration clipDuration = Duration(seconds: 1); // Duration of the song clip to be played, starts at 1 second
  Duration songLength = Duration.zero;
  bool gameCompleted = false; // Flag to track if the game is completed

  // Initialize the game and pick a random song
  void _initializeGame() {
    final randomSong = (songs..shuffle()).first; //Shuffle the list pick the first song
    setState(() {
      currentSongFilePath = randomSong['filePath']!;
    });

    _loadSong();
  }

  // Load the song and get its duration
  Future<void> _loadSong() async {
    await _audioPlayer.setAsset(currentSongFilePath); //load the song asset
    songLength = (await _audioPlayer.load())!; //get the song's total duration

    //play initial 1 sec clip
    _playSongClip();
  }

  //Play the song from the start for the given duration
  void _playSongClip() async {
    //Start playing the song
    await _audioPlayer.seek(Duration.zero); //start from beginning
    await _audioPlayer.play(); //play the song

    // Wait for the duration of the clip
    await Future.delayed(clipDuration); // Wait for the clip duration

    // Stop the audio after the clip duration
    await _audioPlayer.stop();
  }

  //check if the guess is correct and update the attempts and guesses
  void _checkGuess() {
    if (gameCompleted || attempts >= 6) {
      return; //stop if game over or your attempts are 6
    }

    setState(() {
      attempts++;
      guesses.add(currentGuess); //add the current guess to the list
      clipDuration = Duration(seconds: (1 << attempts)); //Double duration (1, 2, 4, 8, 16, 32)
    });

    // Check if the guess is correct
    final correctSong = songs.firstWhere(
      (song) => song['filePath'] == currentSongFilePath,
      orElse: () => {'title': '', 'artist': ''},
    );

    if (currentGuess.toLowerCase() == correctSong['title']!.toLowerCase()) {
      setState(() {
        gameCompleted = true; //Game is done!!
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correct! You guessed it in $attempts attempts!')),
      );
      _audioPlayer.stop();
      _audioPlayer.seek(Duration(seconds: 32)); //play the entire 32 seconds
      _audioPlayer.play();
    } else {
      //If incorrect, replay the song clip
      _audioPlayer.stop();
      _playSongClip();
    }

    //6 attempts -> game over
    if (attempts == 6) {
      setState(() {
        gameCompleted = true; //game is done!!!
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Game Over! The song was: ${correctSong['title']}')),
      );

    }
  }

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harry Styles Heardle'),
        backgroundColor: const Color.fromARGB(255, 250, 218, 221),
      ),
      body: Stack(
        children: [
          //background image
          Positioned.fill(
            child: Image.asset(
              'images/harry_background_blurry.png',
              fit: BoxFit.cover, 
            ),
          ),
          // Content
          // SingleChildScrollView(
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: gameCompleted ? null : _playSongClip,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        currentGuess = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your guess',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 250, 218, 221),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color.fromARGB(255, 219, 74, 146)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 219, 74, 146), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color.fromARGB(255, 219, 74, 146)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 219, 74, 146),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: const Color.fromARGB(255, 219, 74, 146), width: 2),
                      ),
                    ),
                    onPressed: gameCompleted ? null : _checkGuess,
                    child: Text('Submit Guess'),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        for (int i = 0; i < 6; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                color: guesses.length > i
                                    ? guesses[i].toLowerCase() ==
                                            songs.firstWhere((song) => song['filePath'] == currentSongFilePath)['title']!.toLowerCase()
                                        ? const Color.fromARGB(255, 167, 231, 167)
                                        : const Color.fromARGB(255, 255, 126, 117)
                                    : const Color.fromARGB(255, 250, 218, 221),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  guesses.length > i ? guesses[i] : '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Attempts: $attempts/6', style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
            ),
          // ),
        ],
      ),
    );
  }
}
