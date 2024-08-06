import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:practice2/config/config.dart';
import 'package:practice2/pages/register.dart';
import 'package:practice2/pages/showtrip.dart';
import 'package:http/http.dart' as http;

import '../model/request/customer_login_post_req.dart';
import '../model/response/customer_login_post_res.dart';

class loginpage extends StatefulWidget {
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  String text = "";
  int countLogin = 1;
  TextEditingController phoneCTL = TextEditingController();
  TextEditingController passwordCTL = TextEditingController();

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'หมายเลขโทรศัพท์',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 8.0), // Adjusted padding to remove top padding
                  child: TextField(
                    controller: phoneCTL,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: const EdgeInsets.only(
                      top: 25, left: 8, right: 8, bottom: 8),
                  child: Text(
                    'รหัสผ่าน',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: TextField(
                      controller: passwordCTL,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)))),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: register,
                      child: const Text(
                        'ลงทะเบียนใหม่',
                        style: TextStyle(fontSize: 20),
                      )),
                  FilledButton(
                      onPressed: login,
                      child: const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ),
            ),
            Text(text)
          ],
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  void login() {
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
        phone: phoneCTL.text, password: passwordCTL.text);
    http
        .post(Uri.parse("$url/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(req))
        .then(
      (value) {
        log(value.body);
        CustomerLoginPostResponse customerLoginPostResponse =
            customerLoginPostResponseFromJson(value.body);
        log(customerLoginPostResponse.customer.fullname);
        log(customerLoginPostResponse.customer.email);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ShowtripPage(idx : customerLoginPostResponse.customer.idx)));
      },
    ).catchError((error) {
      log('Error $error');
    });
  }


}
