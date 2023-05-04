import 'package:flutter/material.dart';
import "package:math_expressions/math_expressions.dart";
import 'package:flutter/cupertino.dart';


class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _expression = '0';
  String _result = '0';

  void _addToExpression(String value) {
    if (value == '=') {
      _calculateResult();
    } else if (value == 'C') {
      _clear();
    } else if (value == '(') {
      setState(() {
        // Jika _expression saat ini adalah '0', ganti dengan '('
        if (_expression == '0') {
          _expression = '(';
        } else {
          // Jika _expression terakhir adalah angka atau kurung tutup, tambahkan '*' sebelum '('
          String lastChar = _expression[_expression.length - 1];
          if (isNumeric(lastChar) || lastChar == ')') {
            _expression += '*(';
          } else if (isOperator(lastChar)) {
            _expression += '(';
          } else {
            // Jika _expression terakhir adalah kurung buka, tambahkan '*('
            _expression += '*(';
          }
        }
        // Tambahkan tanda kurung pada akhir ekspresi
        _expression += ')';
      });
    } else if (value == ')') {
      // Jangan lakukan apa-apa saat tombol kurung tutup ditekan
    } else {
      setState(() {
        // Jika _expression saat ini adalah '0', ganti dengan angka baru
        if (_expression == '0') {
          _expression = value;
        } else {
          // Jika _expression terakhir adalah kurung buka, tambahkan angka tanpa tanda '*' di awal
          String lastChar = _expression[_expression.length - 1];
          if (lastChar == '(') {
            _expression += value;
          } else {
            // Jika _expression terakhir adalah angka atau operator, tambahkan angka tanpa tanda '*' di awal
            if (isNumeric(lastChar) || isOperator(lastChar)) {
              _expression += value;
            } else {
              _expression += value;
            }
          }
        }
      });
    }
  }

  bool isOperator(String value) {
    return value == '+' || value == '-' || value == '*' || value == '/';
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    final n = num.tryParse(value);
    return n != null && n != double.nan;
  }

  void _calculateResult() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        if (eval == eval.toInt()) {
          _result = eval.toInt().toString();
          _expression = eval.toInt().toString();
        } else {
          _result = eval.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
          _expression = eval.toString();
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _clear() {
    setState(() {
      _expression = '0';
      _result = '0';
    });
  }

  void _backspace() {
    setState(() {
      // Menghapus karakter terakhir dari _expression
      _expression = _expression.substring(0, _expression.length - 1);
      // Jika _expression kosong, reset ke '0'
      if (_expression.isEmpty) {
        _expression = '0';
      }
    });
  }


  Widget _buildButton(String label, {Color color = Colors.white, double fontSize = 32.0, double padding = 24.0}) {
    if (label == '()' || label == '%' || label == '^') {
      return Expanded(
        child: MaterialButton(
          padding: EdgeInsets.all(padding),
          onPressed: () => _addToExpression(label),
          color: color,
          child: Text(
            label,
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          ),
        ),
      );
    } else {
      return Expanded(
        child: RawMaterialButton(
          padding: EdgeInsets.all(padding),
          onPressed: () => _addToExpression(label),
          shape: CircleBorder(),
          fillColor: color,
          child: Text(
            label,
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16.0),
              child: Text(
                _expression,
                style: TextStyle(fontSize: 48.0),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(16.0),
              child: Text(
                _result,
                style: TextStyle(fontSize: 48.0),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min, // tambahkan properti mainAxisSize
            children: <Widget>[
              _buildButton('C', color: Colors.grey),
              _buildButton('()', color: Colors.grey),
              _buildButton('%', color: Colors.grey),
              _buildButton('^', color: Colors.grey),
              _buildButton('+/-', color: Colors.grey),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('7', color: Colors.blue),
              _buildButton('8', color: Colors.blue),
              _buildButton('9', color: Colors.blue),
              _buildButton('/', color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('4', color: Colors.blue),
              _buildButton('5', color: Colors.blue),
              _buildButton('6', color: Colors.blue),
              _buildButton('*', color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('1', color: Colors.blue),
              _buildButton('2', color: Colors.blue),
              _buildButton('3', color: Colors.blue),
              _buildButton('-', color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('0', color: Colors.blue),
              _buildButton('.', color: Colors.blue),
              _buildButton('=', color: Colors.orange),
              _buildButton('+', color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}
