import 'package:flutter/material.dart';
import 'package:Monitoring/bottom_navbar.dart';
import 'login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: AestheticCircle(
              diameter: 300,
              color: Colors.blue[100]!,
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: AestheticCircle(
              diameter: 400,
              color: Colors.blue[50]!,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(187, 222, 251, 1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/logo.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomNavigation(
                                        initialIndex: 2,
                                      )),
                            );
                          },
                          child: Text("Kirim Kode"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: "Kode Verifikasi",
                        prefixIcon: Icon(Icons.key),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavigation(
                                    initialIndex: 2,
                                  )),
                        );
                      },
                      child: Text("Konfirmasi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Anda memiliki akun? ",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: Colors.blue[800],
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AestheticCircle extends StatelessWidget {
  final double diameter;
  final Color color;

  const AestheticCircle({
    Key? key,
    required this.diameter,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
