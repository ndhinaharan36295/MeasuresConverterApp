import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MeasuresConverterAppHomePage(title: 'Measures Converter Application Home Page'),
    );
  }
}

class MeasuresConverterAppHomePage extends StatefulWidget {
  const MeasuresConverterAppHomePage({super.key, required this.title});

  final String title;

  @override
  State<MeasuresConverterAppHomePage> createState() => _MeasuresConverterAppHomePageState();
}

class _MeasuresConverterAppHomePageState extends State<MeasuresConverterAppHomePage> {
  TextEditingController _inputValueField = TextEditingController();
  String _initialMeasureUnit = 'Meters';
  String _toConvertMeasureUnit = 'Kilometers';
  String _result = '';

  final List<String> _allAvailableUnites = ['Meters', 'Kilometers', 'Feet', 'Miles',
    'Grams', 'Kilograms', 'Pounds', 'Ounces', 'Liters', 'Milliliters'];

  void _convert() {
    final input = double.tryParse(_inputValueField.text);

    if (input == null) {
      setState(() {
        _result = 'Please try a valid number for input';
      });
      return;
    }

    if (_initialMeasureUnit == _toConvertMeasureUnit) {
      setState(() {
        _result = '${_inputValueField.text} $_initialMeasureUnit are ${input.toStringAsFixed(5)} $_toConvertMeasureUnit';
      });
      return;
    }

    final conversionFactors = {
      'Meters': {'Kilometers': 0.001, 'Feet': 3.28084, 'Miles': 0.000621371},
      'Kilometers': {'Meters': 1000.0, 'Feet': 3280.84, 'Miles': 0.621371},
      'Feet': {'Meters': 0.3048, 'Kilometers': 0.0003048, 'Miles': 0.000189394},
      'Miles': {'Meters': 1609.34, 'Kilometers': 1.60934, 'Feet': 5280.0},
      'Grams': {'Kilograms': 0.001, 'Pounds': 0.00220462, 'Ounces': 0.035274},
      'Kilograms': {'Grams': 1000.0, 'Pounds': 2.20462, 'Ounces': 35.274},
      'Pounds': {'Grams': 453.592, 'Kilograms': 0.453592, 'Ounces': 16.0},
      'Ounces': {'Grams': 28.3495, 'Kilograms': 0.0283495, 'Pounds': 0.0625,
        'Liters': 0.0295735, 'Milliliters': 29.5735},
      'Liters': {'Milliliters': 1000.0, 'Ounces': 33.814},
      'Milliliters': {'Liters': 0.001, 'Ounces': 0.033814 },
    };

    double conversionFactor =
        conversionFactors[_initialMeasureUnit]?[_toConvertMeasureUnit] ??
            double.infinity;

    if (conversionFactor == double.infinity) {
      setState(() {
        _result = 'Please try a valid conversion';
      });
      return;
    }

    setState(() {
      double finalResult = input * conversionFactor;
      _result = '${_inputValueField.text} $_initialMeasureUnit are ${finalResult.toStringAsFixed(5)} $_toConvertMeasureUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text for input value field
            Text(
              'Value',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            // Input Field
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: TextField(
                  controller: _inputValueField,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Enter value',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'From',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            // DropdownButton for initial measure unit
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _initialMeasureUnit,
                  items: _allAvailableUnites.map((unit) { return
                    DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _initialMeasureUnit = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'To',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            // DropdownButton for 'to be converted' measure unit
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: _toConvertMeasureUnit,
                    items: _allAvailableUnites.map((unit) { return
                      DropdownMenuItem(value: unit, child: Text(unit));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _toConvertMeasureUnit = value!;
                      });
                    },
                  ),
              ),
            ),
            const SizedBox(height: 20),

            // Convert Button
            ElevatedButton(
              onPressed: _convert,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(50, 50), // Set the width and height
                // to be equal
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Make the corners square
                ),
              ),
              child: const Text('Convert'),
            ),
            const SizedBox(height: 35),

            // Result Display
            Text(
              _result,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
