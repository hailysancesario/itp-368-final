import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Harry Styles Heardle"),
      backgroundColor: const Color.fromARGB(255, 250, 218, 221), ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/harry_home_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100, 
                      borderRadius: BorderRadius.circular(12.0), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26, 
                          offset: Offset(0, 4), 
                          blurRadius: 6.0, 
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "How to Play",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.music_note, color: Colors.blue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Listen to the intro, then enter the correct Harry Styles song.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.volume_up, color: Colors.green),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Skipped or incorrect attempts unlock more of the intro.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.thumb_up, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Answer in as few tries as possible!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 219, 74, 146),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: const Color.fromARGB(255, 219, 74, 146), width: 2),
                      ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameScreen()),
                        );
                      },
                      child: Text("Start Game"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
