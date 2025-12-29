import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFEB),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.13,

              child: Image.asset(
                "lib/icons/graduation.png",
                color: Color(0xFF2F4156),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.001),
          Text(
            "Login",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F4156),
            ),
          ),
          Text(
            "Access Your Account",
            style: TextStyle(fontSize: 15, color: Color(0xFF2F4156)),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Signincards(RoleVar: RoleVariables(role: "Student", color: Color(0xFF2F4156)),),
              // SizedBox(width: MediaQuery.of(context).size.width*0.05,),
              // Signincards(RoleVar: RoleVariables(role: "Faculty", color: Color(0xFF2F4156)),),
              // SizedBox(width: MediaQuery.of(context).size.width*0.05,),
              // Signincards(RoleVar: RoleVariables(role: "Admin", color: Color(0xFF2F4156)),),
              Container(
                color: Color(0xFF2F4156),
                width: MediaQuery.of(context).size.width * 0.17,
                child: Center(
                  child: Image.asset(
                    "lib/icons/graduation.png",
                    color: Color(0xFFF5EFEB),
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
