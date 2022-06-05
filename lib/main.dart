import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  static const Color backgroundColor = Color.fromARGB(256, 30, 30, 30);

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json Placeholder App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  static String jokeToDisplay = "Wait a second...";
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  String jokeText = "Wait a second...";

  HomePageState(){
    updateJoke();
  }

  void updateJoke() async{
    String newJokeText = await HomePageState.getNewTextJoke();
    setState(() {
      jokeText = newJokeText;
    });
  }

  static Future<String> getNewTextJoke() async{
    http.Response data = await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));
    // print(data.body);
    Map<String, dynamic> jsonData = json.decode(data.body);
    return Future(() => jsonData["value"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      appBar: null,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              JokerCard(jokeText),
              const SizedBox(height: 40),
              LikeButton("I liked this joke", this)
            ]
        )
      )
    );
  }
}


class JokerCard extends StatelessWidget{
  final String jokeText;
  const JokerCard(this.jokeText, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      width: 360,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 30, 30, 30),
          border: Border.all(
          color: Colors.white,
          width: 5
        ),
        borderRadius: BorderRadius.circular(25)
      ),

      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child:JokerText(jokeText)
        ),
      )
    );
  }
}

class JokerText extends StatelessWidget{
  final String jokeText;
  static const TextStyle jokerTextStyle = TextStyle(
      color: Colors.white,
      fontFamily: "Arial",
      fontWeight: FontWeight.bold,
      fontSize: 12
  );

  const JokerText(this.jokeText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Text(
      jokeText,
      style: JokerText.jokerTextStyle
    );
  }
}

class LikeButton extends StatelessWidget{
  final String buttonText;
  final HomePageState stateToChange;
  const LikeButton(this.buttonText, this.stateToChange, {Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context){
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(MyApp.backgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.white)
                )
            )
        ),
        onPressed: stateToChange.updateJoke,
        child: const Text(
          "I liked this joke",
          style: JokerText.jokerTextStyle,
        ));
  }
}






