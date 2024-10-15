import 'package:flutter/material.dart';
import 'package:nandini_beauty_store/Homescreen/HomePage.dart';
import 'package:nandini_beauty_store/auth/UserSignUP.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  //we neet three text editing controller

  final username=TextEditingController();
  final password=TextEditingController();
  final housingcode=TextEditingController();

  //we need a bool variable to hide password
  bool isVisible = false;

  //we have create global key for our form
  final formkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            //We put all our text field to form to be controlled and not allow empty
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    //Admin login image
                    Image.asset(
                      "assets/user_login.jpg",
                      width: 210,
                    ),
                    const SizedBox(height: 15,),

                    //Username Field
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.pinkAccent.withOpacity(.3)
                      ),
                      child: TextFormField(
                        controller: username,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Username is required.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: InputBorder.none,
                          hintText: "Username",
                        ),
                      ),
                    ),

                    //Password Field
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.pinkAccent.withOpacity(.3)
                      ),
                      child: TextFormField(
                        controller: password,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Password is required.";
                          }
                          return null;
                        },
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(onPressed: () {
                            //In here password show and hide a toggle button
                            setState(() {
                              //toggle button
                              isVisible=!isVisible;

                            });

                          }, icon: Icon(isVisible? Icons.visibility : Icons.visibility_off)),
                        ),
                      ),
                    ),

                    //Login Button
                    const SizedBox(height: 10,),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.pinkAccent
                      ),
                      child: TextButton(onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          final prefs = await SharedPreferences.getInstance();
                          if (username.text == 'admin' && password.text == 'admin') {
                            // Admin login
                            prefs.setBool('isLoggedIn', true);
                            prefs.setBool('isAdmin', true);
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => HomePage()));
                          } else {
                            // Regular user login (validate against stored credentials)
                            final storedUsername = prefs.getString('username');
                            final storedPassword = prefs.getString('password');

                            if (username.text == storedUsername &&
                                password.text == storedPassword) {
                              prefs.setBool('isLoggedIn', true);
                              prefs.setBool('isAdmin', false);
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => HomePage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                  "Invalid username or password",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ));
                            }
                          }
                        }
                      }, child: const Text("LOGIN",style: TextStyle(color: Colors.white),)),
                    ),

                    //sign up button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an extisting account?"),
                        TextButton(onPressed: () {
                          //Navigator to New Admin Login
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserSignUp()));
                        }, child: const Text("SIGN UP",style: TextStyle(color: Colors.pinkAccent),))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
