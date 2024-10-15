import 'package:flutter/material.dart';
import 'package:nandini_beauty_store/auth/UserLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  //we neet Three text editing controller

  final username=TextEditingController();
  final email=TextEditingController();
  final phone=TextEditingController();
  final password=TextEditingController();
  final confirmPassword=TextEditingController();

  //we need a bool variable to hide password
  bool isVisible = false;

  //we have create global key for our form
  final formkey=GlobalKey<FormState>();

  // Static list to hold registered users

  /*Future<void> _sendEmail(String username, String password, String email) async {
    final response = await http.post(
      Uri.parse('http://your-server-url/send-email'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email');
    }
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const ListTile(
                          title: Center(child: Text("Sign Up",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),)),
                        ),
                      ),

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

                      //E-mail Field
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.pinkAccent.withOpacity(.3)
                        ),
                        child: TextFormField(
                          controller: email,
                          validator: (value){
                            if(value!.isEmpty){
                              return "E-mail ID is required.";
                            } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                              return "Please enter a valid email address.";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            border: InputBorder.none,
                            hintText: "E-mail ID",
                          ),
                        ),
                      ),

                      //Phone Field
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.pinkAccent.withOpacity(.3)
                        ),
                        child: TextFormField(
                          controller: phone,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Phone Number is required.";
                            } else if (!RegExp(r"^[0-9]{10,15}$").hasMatch(value)) {
                              return "Please enter a valid phone number.";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone),
                            border: InputBorder.none,
                            hintText: "Contact",
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

                      //Confirm password Field
                      //now we check password matched or not matched.
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.pinkAccent.withOpacity(.3)
                        ),
                        child: TextFormField(
                          controller: confirmPassword,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Confirm Password is required.";
                            }else if(password.text!=confirmPassword.text){
                              return "Password Doesn't Matched.";
                            }
                            return null;
                          },
                          obscureText: !isVisible,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.lock),
                            border: InputBorder.none,
                            hintText: "Re-Enter Password",
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
                            await prefs.setString('username', username.text);
                            await prefs.setString('email', email.text);
                            await prefs.setString('phone', phone.text);
                            await prefs.setString('password', password.text);
                            // Navigate to the login page
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserLoginPage()));
                          }

                        }, child: const Text("SIGN UP",style: TextStyle(color: Colors.white),)),
                      ),

                      //sign up button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(onPressed: () {
                            //Navigator to New Admin Login
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserLoginPage()));
                          }, child: const Text("LOGIN",style: TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.bold,fontSize: 18),))
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}