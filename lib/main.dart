import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter App',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _FromController = TextEditingController();
  final TextEditingController _ToController = TextEditingController();
  double? result;
  String? selectedFrom = 'From';
  String? selectedTo = 'To';

  double convertTemperature(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) {
      return value; // If both units are the same, return the original value
    }

    // Convert from 'fromUnit' to Celsius as a common intermediary
    double celsius;
    if (fromUnit == 'Celsius') {
      celsius = value;
    } else if (fromUnit == 'Fahrenheit') {
      celsius = (value - 32) * 5 / 9;
    } else if (fromUnit == 'Kelvin') {
      celsius = value - 273.15;
    } else {
      throw ArgumentError('Invalid fromUnit');
    }

    // Convert from Celsius to the 'toUnit'
    if (toUnit == 'Celsius') {
      return celsius;
    } else if (toUnit == 'Fahrenheit') {
      return (celsius * 9 / 5) + 32;
    } else if (toUnit == 'Kelvin') {
      return celsius + 273.15;
    } else {
      throw ArgumentError('Invalid toUnit');
    }
  }

  void _calculateTemp() {
    final double fromValue = double.tryParse(_FromController.text) ?? 0;

    String fromUnit = selectedFrom!;
    String toUnit = selectedTo!;

    result = convertTemperature(fromValue, fromUnit, toUnit);

    _ToController.text = result?.toString() ?? '';
  }

  void _reset() {
    _FromController.text = '';
    _ToController.text = '';
    selectedFrom = 'From';
    selectedTo = 'To';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        title: Text('Temperature Converter'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedFrom,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown),
                          ),
                        ),
                        items: <String>['From', 'Celsius', 'Kelvin', 'Fahrenheit'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFrom = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _FromController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'From Temp',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedTo,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown),
                          ),
                        ),
                        items: <String>['To', 'Celsius', 'Kelvin', 'Fahrenheit'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTo = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _ToController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Result',
                        ),
                        keyboardType: TextInputType.number,
                        readOnly: true, // Make this field read-only
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60, // Set the desired height
                      child: ElevatedButton(
                        onPressed: _calculateTemp,
                        child: Text(
                          "Convert",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 60, // Set the desired height
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _reset();
                          });
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 150, // Set the radius to half the width and height of the container
                  child: selectedTo == 'Celsius'
                      ? Image.asset("assets/images/c.png")
                      : selectedTo == 'Kelvin'
                      ? Image.asset("assets/images/k.png")
                      :selectedTo == 'Fahrenheit' ?
                      Image.asset("assets/images/F.png") :
                      Icon(
                        Icons.question_mark,
                        size: 150,
                      )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
