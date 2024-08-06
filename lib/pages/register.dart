import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:practice2/model/response/customer_create_post_res.dart';
import 'package:practice2/pages/login.dart';
import 'package:http/http.dart' as http;

import '../model/request/customer_create_post_res.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // เพิ่ม controllers สำหรับแต่ละ TextField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ลงทะเบียนสมาชิกใหม่"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 8),
                  child: const Text(
                    'ชื่อ-นามสกุล',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      bottom: 8.0), // Adjusted padding to remove top padding
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 8),
                  child: Text(
                    'หมายเลขโทรศัพท์',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      bottom: 8.0), // Adjusted padding to remove top padding
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 8),
                  child: Text(
                    'อีเมล์',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      bottom: 8.0), // Adjusted padding to remove top padding
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 8),
                  child: Text(
                    'รหัสผ่าน',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      bottom: 8.0), // Adjusted padding to remove top padding
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 8),
                  child: Text(
                    'ยินยันรหัสผ่าน',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      bottom: 8.0), // Adjusted padding to remove top padding
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: register,
                      child: const Text(
                        'สมัครสมาชิก',
                        style: const TextStyle(fontSize: 16),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: login,
                      child: const Text(
                        'หากมีบัญชีอยู่แล้ว',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  TextButton(
                      onPressed: login,
                      child: const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => loginpage()));
  }

void register() async {
  // ตรวจสอบว่าข้อมูลถูกกรอกครบถ้วนหรือไม่
  if (_nameController.text.isEmpty ||
      _phoneController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _confirmPasswordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
    );
    return;
  }

  // ตรวจสอบว่ารหัสผ่านและการยืนยันรหัสผ่านตรงกันหรือไม่
  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน')),
    );
    return;
  }

  // ตรวจสอบว่ามี customer คนนี้อยู่แล้วหรือไม่
  try {
    final response = await http.get(Uri.parse("http://192.168.137.1:3000/customers"));
    if (response.statusCode == 200) {
      List<dynamic> customers = json.decode(response.body);
      bool customerExists = customers.any((customer) => 
        customer['email'] == _emailController.text || 
        customer['phone'] == _phoneController.text
      );

      if (customerExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('อีเมลหรือหมายเลขโทรศัพท์นี้มีอยู่ในระบบแล้ว')),
        );
        return;
      }
    } else {
      throw Exception('Failed to load customers');
    }
  } catch (e) {
    log('Error fetching customers: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เกิดข้อผิดพลาดในการตรวจสอบข้อมูล กรุณาลองใหม่อีกครั้ง')),
    );
    return;
  }

  // ดำเนินการลงทะเบียนหากไม่มี customer คนนี้อยู่แล้ว
  ImagesResponse req = ImagesResponse(
    fullname: _nameController.text,
    phone: _phoneController.text,
    email: _emailController.text,
    image: "http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png",
    password: _passwordController.text
  );

  try {
    final response = await http.post(
      Uri.parse("http://192.168.137.1:3000/customers"),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: imagesResponseToJson(req)
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log(response.body);
      CustomerCreatePostResponse customerCreatePostResponse =
          customerCreatePostResponseFromJson(response.body);
      log(customerCreatePostResponse.message);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ลงทะเบียนสำเร็จ')),
      );
      
      login();
    } else {
      throw Exception('Failed to register customer');
    }
  } catch (e) {
    log('Error registering customer: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เกิดข้อผิดพลาดในการลงทะเบียน กรุณาลองใหม่อีกครั้ง')),
    );
  }
}

  @override
  void dispose() {
    // ทำลาย controllers เมื่อไม่ได้ใช้งานแล้ว
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
