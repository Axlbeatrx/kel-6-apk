import 'package:flutter/material.dart';
import '../api/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void register(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.registerUser(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Unknown error")),
      );

      if (response['message'] == "User registered successfully") {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background-galang.jpg', // Ganti dengan path gambar yang diinginkan
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: "Name"),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: "Email"),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(labelText: "Password"),
                          obscureText: true,
                        ),
                        SizedBox(height: 16),
                        isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () => register(context),
                                child: Text("Register"),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
