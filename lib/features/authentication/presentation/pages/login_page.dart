import 'package:flutter/material.dart';
import 'package:temanmu/core/client/_client.dart';
import 'package:temanmu/services/router_service.dart';
import 'package:temanmu/services/shared_preference_service.dart';
import 'dart:convert';
import 'package:temanmu/core/constants/_constants.dart';
import 'package:temanmu/services/toast_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final body = {'emailOrUsername': username, 'password': password};
    final result = await apiCall(
      postIt('http://10.0.2.2:8080/auth/login', model: body),
    );
    setState(() => _loading = false);
    result.fold(
      (failure) {
        ToastService.show(context, failure.message);
      },
      (response) async {
        try {
          final dynamic raw = response.data;
          final data = raw is String ? json.decode(raw) : raw;
          final token = data['data']['token'];
          final userId = data['data']['userId'];
          final username = data['data']['username'];
          final roles = data['data']['roles'] as List<dynamic>?;
          
          await SharedPreferencesService.saveToken(token);
          await SharedPreferencesService.saveString(
            PreferencesKeys.userId,
            userId,
          );
          await SharedPreferencesService.saveString(
            PreferencesKeys.displayName,
            username,
          );
          
          // Save roles as string list
          if (roles != null) {
            final rolesList = roles.map((role) => role.toString()).toList();
            await SharedPreferencesService.saveStringList(
              PreferencesKeys.roles,
              rolesList,
            );
          }
          
          print("tokennya : " + token);
          print("userId : " + userId);
          print("username : " + username);
          print("roles : " + (roles?.toString() ?? 'null'));
          if (!mounted) return;
          router.go('/main');
        } catch (e) {
          ToastService.show(
            context,
            'Login berhasil tetapi gagal memproses token.',
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Username required'
                              : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Password required'
                              : null,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _loading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
