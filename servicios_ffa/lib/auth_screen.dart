import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  bool _isSignedUp = false;
  bool _isLoggedIn = false;

  Future<void> _signUp() async {
    try {
      final userAttributes = {
        CognitoUserAttributeKey.email: _emailController.text.trim(),
        CognitoUserAttributeKey.phoneNumber: '+50212345678', // reemplaza con el número real
      };

      final res = await Amplify.Auth.signUp(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      setState(() {
        _isSignedUp = res.isSignUpComplete == false;
      });

      print("Sign up: ${res.isSignUpComplete}");
    } catch (e) {
      print("Error en registro: $e");
    }
  }

  Future<void> _confirmCode() async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
        username: _emailController.text.trim(),
        confirmationCode: _codeController.text.trim(),
      );

      print("Confirmación: ${res.isSignUpComplete}");
      if (res.isSignUpComplete) {
        setState(() => _isSignedUp = false);
      }
    } catch (e) {
      print("Error al confirmar código: $e");
    }
  }

  Future<void> _signIn() async {
    try {
      final res = await Amplify.Auth.signIn(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => _isLoggedIn = res.isSignedIn);
      print("Login: ${res.isSignedIn}");
    } catch (e) {
      print("Error al iniciar sesión: $e");
    }
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
      setState(() => _isLoggedIn = false);
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auth with Amplify")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoggedIn
            ? Column(
                children: [
                  Text("Sesión iniciada"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text("Cerrar sesión"),
                  )
                ],
              )
            : Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email o usuario'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                  ),
                  if (_isSignedUp)
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(labelText: 'Código de verificación'),
                    ),
                  SizedBox(height: 10),
                  if (_isSignedUp)
                    ElevatedButton(
                      onPressed: _confirmCode,
                      child: Text("Confirmar código"),
                    )
                  else
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _signUp,
                          child: Text("Registrarse"),
                        ),
                        ElevatedButton(
                          onPressed: _signIn,
                          child: Text("Iniciar sesión"),
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
