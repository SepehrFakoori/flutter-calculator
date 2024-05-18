import 'package:calculator_application/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  var userInput = '';
  var result = '';

  void buttonPressed(String text) {
    setState(() {
      userInput += text;
    });
  }

  Widget getRow(List<String> signs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buttons(signs[0]),
        buttons(signs[1]),
        buttons(signs[2]),
        buttons(signs[3]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 30,
                  child: Container(
                    height: 100,
                    color: backgroundGrey,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      padding: EdgeInsets.only(top: 10, right: 15),
                      decoration: BoxDecoration(
                          color: backgroundGreyDark,
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            userInput,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textGreen,
                            ),
                          ),
                          Text(
                            result,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 62,
                              fontWeight: FontWeight.bold,
                              color: textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 72,
                  child: Container(
                    height: 200,
                    color: backgroundGrey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getRow(["ac", "ce", "%", "/"]),
                        getRow(["7", "8", "9", "*"]),
                        getRow(["4", "5", "6", "-"]),
                        getRow(["1", "2", "3", "+"]),
                        getRow(["00", "0", ".", "="]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isOperator(String text) {
    var list = ["ac", "ce", "%", "/", "*", "-", "+", "="];
    for (var item in list) {
      if (text == item) {
        return true;
      }
    }
    return false;
  }

  Color getBackgroundColor(String text) {
    if (isOperator(text)) {
      return backgroundGreyDark;
    } else {
      return backgroundGrey;
    }
  }

  Color getTextColor(String text) {
    if (isOperator(text)) {
      return textGreen;
    } else {
      return textGrey;
    }
  }

  TextButton buttons(String sign) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: getBackgroundColor(sign),
        shape: CircleBorder(
          side: BorderSide(width: 0, color: Colors.transparent),
        ),
      ),
      onPressed: () {
        if (sign == 'ce') {
          setState(() {
            if (userInput.length > 0) {
              userInput = userInput.substring(0, userInput.length - 1);
            }
          });
        } else if (sign == "ac") {
          setState(() {
            userInput = "";
            result = "";
          });
        } else if (sign == "=") {
          Parser parser = Parser();
          Expression expression = parser.parse(userInput);
          ContextModel contextModel = ContextModel();
          double eval = expression.evaluate(EvaluationType.REAL, contextModel);
          setState(() {
            result = eval.toString();
          });
        } else {
          buttonPressed(sign);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          sign,
          style: TextStyle(fontSize: 26, color: getTextColor(sign)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
