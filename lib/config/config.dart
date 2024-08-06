import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';

class Configuration {
  static Future<Map<String, dynamic>> getConfig() async {
    try {
      developer.log('Attempting to load config file');
      final String jsonString = await rootBundle.loadString('assets/config/config.json');
      developer.log('Raw config content: $jsonString');
      
      final Map<String, dynamic> config = jsonDecode(jsonString) as Map<String, dynamic>;
      developer.log('Config parsed: $config');
      
      return config;
    } catch (e) {
      developer.log('Error loading config: $e', error: e, stackTrace: StackTrace.current);
      rethrow;
    }
  }
}