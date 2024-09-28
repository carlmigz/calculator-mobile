import 'package:calculator/widgets/color_palletes.dart';
import 'package:calculator/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = "0";
  String expression = "";
  bool lastInputIsOperator = false;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        output = "0";
        expression = "";
        lastInputIsOperator = false;
      } else if (buttonText == "⌫") {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
          output = expression.isEmpty ? "0" : expression;
          lastInputIsOperator = _isOperator(
              expression.isNotEmpty ? expression[expression.length - 1] : '');
        }
      } else if (buttonText == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          output = eval.toString().replaceAll(RegExp(r'\.0$'), '');
          expression = output;
        } catch (e) {
          output = "Error";
        }
        lastInputIsOperator = false;
      } else {
        if (_isOperator(buttonText)) {
          if (lastInputIsOperator) {
            return;
          } else {
            lastInputIsOperator = true;
          }
        } else {
          lastInputIsOperator = false;
        }

        if (output == "0" && buttonText != ".") {
          output = buttonText;
        } else {
          output += buttonText;
        }

        expression += buttonText;
      }
    });
  }

  bool _isOperator(String text) {
    return text == "+" ||
        text == "-" ||
        text == "*" ||
        text == "/" ||
        text == "%";
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      'C',
      '⌫',
      '%',
      '/',
      '7',
      '8',
      '9',
      '*',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '0',
      '.',
      '=',
    ];

    return Scaffold(
      backgroundColor: blackColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                output,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            color: grayColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: buttons.length,
                itemBuilder: (context, index) {
                  return CustomButton(
                    text: buttons[index],
                    onPressed: () {
                      buttonPressed(buttons[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
