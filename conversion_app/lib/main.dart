/// Measures Converter Application
/// Author: Unique Karanjit
/// Created: 2025-03-09
/// 
/// This application provides functionality to convert between different units
/// of measurement including length and weight.

import 'package:flutter/material.dart';

void main() {
  runApp(ConversionApp());
}

/// Main application widget that sets up the MaterialApp
class ConversionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Measures Converter',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MeasuresConverter(),
  );
}

/// MeasuresConverter widget that handles the conversion interface
class MeasuresConverter extends StatefulWidget {
  @override
  _MeasuresConverterState createState() => _MeasuresConverterState();
}

/// State class for MeasuresConverter that manages conversion logic
class _MeasuresConverterState extends State<MeasuresConverter> {
  // Controller for the input text field
  final TextEditingController _controller = TextEditingController();
  
  // Current selected units for conversion
  String _fromUnit = 'Meter';
  String _toUnit = 'Centimeter';
  
  // Stores the result of conversion
  String _result = '';

  /// Map of measurement categories and their respective units
  final Map<String, List<String>> _measurementUnits = {
    'Length': ['Meter', 'Centimeter', 'Kilometer', 'Mile', 'Foot'],
    'Weight': ['Kilogram', 'Gram', 'Pound', 'Ounce'],
  };

  /// Conversion factors for different units
  /// The first level key is the source unit
  /// The second level key is the target unit
  /// The value is the multiplication factor to convert from source to target
  final Map<String, Map<String, double>> _conversionFactors = {
    'Meter': {
      'Centimeter': 100,
      'Kilometer': 0.001,
      'Mile': 0.000621371,
      'Foot': 3.28084
    },
    'Centimeter': {
      'Meter': 0.01,
      'Kilometer': 0.00001,
      'Mile': 0.00000621371,
      'Foot': 0.0328084
    },
    'Kilometer': {
      'Meter': 1000,
      'Centimeter': 100000,
      'Mile': 0.621371,
      'Foot': 3280.84
    },
    'Mile': {
      'Meter': 1609.34,
      'Centimeter': 160934,
      'Kilometer': 1.60934,
      'Foot': 5280
    },
    'Foot': {
      'Meter': 0.3048,
      'Centimeter': 30.48,
      'Kilometer': 0.0003048,
      'Mile': 0.000189394
    },
    'Kilogram': {
      'Gram': 1000,
      'Pound': 2.20462,
      'Ounce': 35.274
    },
    'Gram': {
      'Kilogram': 0.001,
      'Pound': 0.00220462,
      'Ounce': 0.035274
    },
    'Pound': {
      'Kilogram': 0.453592,
      'Gram': 453.592,
      'Ounce': 16
    },
    'Ounce': {
      'Kilogram': 0.0283495,
      'Gram': 28.3495,
      'Pound': 0.0625
    }
  };

  /// Returns a list of available target units based on the selected source unit
  /// Filters units from the same measurement category
  List<String> _getToUnits() {
    if (_fromUnit.isEmpty) return [];
    
    for (var category in _measurementUnits.entries) {
      if (category.value.contains(_fromUnit)) {
        return category.value.where((unit) => unit != _fromUnit).toList();
      }
    }
    return [];
  }

  /// Format number to always show 2 decimal places
  String _formatNumber(double number) {
    return number.toStringAsFixed(2);
  }

  /// Performs the conversion calculation based on user input
  /// Validates input and updates the result state
  void _convert() {
    // Parse the input value
    double? input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _result = 'Please enter a valid number';
      });
      return;
    }

    setState(() {
      // Handle same unit conversion
      if (_fromUnit == _toUnit) {
        _result = '${_formatNumber(input)} $_fromUnit is ${_formatNumber(input)} $_toUnit';
        return;
      }

      // Perform conversion using conversion factors
      double? conversionFactor = _conversionFactors[_fromUnit]?[_toUnit];
      if (conversionFactor != null) {
        double result = input * conversionFactor;
        _result = '${_formatNumber(input)} $_fromUnit is ${_formatNumber(result)} $_toUnit';
      } else {
        _result = 'Conversion not available';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Measures Converter')),
      // Main layout with padding
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field for value
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            
            // Source unit selection
            Text('From:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _fromUnit,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _fromUnit = value!;
                  _toUnit = _getToUnits().first;
                });
              },
              items: [
                ..._measurementUnits['Length']!.map((unit) => 
                  DropdownMenuItem(value: unit, child: Text(unit))),
                ..._measurementUnits['Weight']!.map((unit) => 
                  DropdownMenuItem(value: unit, child: Text(unit))),
              ],
            ),
            SizedBox(height: 20),
            
            // Target unit selection
            Text('To:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _toUnit,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _toUnit = value!;
                });
              },
              items: _getToUnits()
                  .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                  .toList(),
            ),
            
            // Convert button
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            
            // Result display
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
