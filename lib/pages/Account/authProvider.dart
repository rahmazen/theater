import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthModel {
  final String accessToken;
  final String refreshToken;
  final String username;
  final String role;
  final String email;
  final String phone;
  final String fullname;
  final String image;
  final int points ;

  // Constructor and serialization methods
  AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.role,
    required this.email,
    required this.phone,
    required this.fullname,
    required this.image,
    required this.points,
  });

  // Convert JSON to AuthModel
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['access'] ?? '',
      refreshToken: json['refresh'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      fullname: json['fullname'] ?? '',
      image: json['image'] ?? '',
      points: json['points'] ?? 0,
    );
  }

  // Convert AuthModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
      'username': username,
      'role': role,
      'email': email,
      'phone': phone,
      'fullname': fullname,
      'image': image,
      "points" : points
    };
  }
}

class AuthProvider with ChangeNotifier {
  AuthModel? _authData;
  bool _isAuthenticated = false;

  AuthModel? get authData => _authData;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> init() async {
    await _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authJson = prefs.getString('auth_data');

    if (authJson != null) {
      try {
        _authData = AuthModel.fromJson(json.decode(authJson));
        _isAuthenticated = true;
      } catch (e) {
        _authData = null;
        _isAuthenticated = false;
      }
    }
    notifyListeners();
  }

  Future<void> signIn(Map<String, dynamic> authData) async {
    _authData = AuthModel.fromJson(authData);
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', json.encode(authData));
    notifyListeners();
  }

  // Sign out method to clear authentication data
  Future<void> signOut() async {
    _authData = null;
    _isAuthenticated = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
    notifyListeners();
  }

  // Method to update tokens when refreshing
  Future<void> updateTokens(String accessToken, String refreshToken) async {
    if (_authData != null) {
      final updatedAuthData = AuthModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        username: _authData!.username,
        role: _authData!.role,
        fullname: _authData!.fullname,
        email: _authData!.email,
        phone: _authData!.phone,
        image: _authData!.image,
        points: _authData!.points
      );

      _authData = updatedAuthData;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_data', json.encode(updatedAuthData.toJson()));
      notifyListeners();
    }
  }
}