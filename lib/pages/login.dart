import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:triviaapp/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Simple login validation (replace with your actual authentication logic)
    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Simulate login process
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Navigate to home page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home(username: username)),
        );
      });
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Credentials"),
          content: const Text("Please enter a valid username and password."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to sign in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // Successfully signed in
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(
              username: googleUser.displayName ?? 'Google User',
            ),
          ),
        );
      }
    } catch (error) {
      // Handle sign-in errors
      String errorMessage = 'Google Sign-In failed';

      if (error is PlatformException) {
        switch (error.code) {
          case 'sign_in_canceled':
            errorMessage = 'Sign-in was canceled';
            break;
          case 'network_error':
            errorMessage = 'Network error occurred';
            break;
          default:
            errorMessage = 'An unexpected error occurred: ${error.message}';
        }
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showGitHubProfile(String username) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('GitHub Profile - $username'),
        content: Text('GitHub: https://github.com/$username'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background_login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo section
                  Image.asset(
                    "images/emsi.png",
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),

                  // Login Container
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 1, 13, 88),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Username TextField
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Pseudoname",
                            prefixIcon: const Icon(Icons.person,
                                color: Color(0xFF6A9BF4)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Password TextField
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock,
                                color: Color(0xFF6A9BF4)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xFF6A9BF4),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Loading or Login Button
                        _isLoading
                            ? const CircularProgressIndicator()
                            : Column(
                                children: [
                                  // Standard Login Button
                                  ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 115, 152, 219),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 15),
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  // Google Sign-In Button
                                  ElevatedButton.icon(
                                    icon: Image.asset('images/google_logo.png',
                                        height: 24, width: 24),
                                    label: const Text(
                                        'OAuth2 Using Google (Beta)'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 245, 4, 4),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                    ),
                                    onPressed: _handleGoogleSignIn,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // GitHub Buttons Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showGitHubProfile('SCOTTGeek-dev'),
                        icon: const Icon(Icons.person, color: Colors.white),
                        label: const Text('SCOTTGeek-dev'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () => _showGitHubProfile('malakhajjaj'),
                        icon: const Icon(Icons.person, color: Colors.white),
                        label: const Text('hajjajmalak'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
