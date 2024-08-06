// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:practice2/config/config.dart';
// import 'package:practice2/model/response/get_profile.dart';

// class ProfilePage extends StatefulWidget {
//   final int idx;

//   const ProfilePage({Key? key, required this.idx}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late Future<GetProfile> futureProfile;
//   late String url;

//   @override
//   void initState() {
//     super.initState();
//     Configuration.getConfig().then(
//       (config) {
//         url = config['apiEndpoint'];
//         setState(() {
//           futureProfile = fetchProfile();
//         });
//       },
//     );
//   }

//   Future<GetProfile> fetchProfile() async {
//     try {
//       final response = await http.get(Uri.parse('$url/customers/${widget.idx}'));

//       if (response.statusCode == 200) {
//         return getProfileFromJson(response.body);
//       } else {
//         throw Exception('Failed to load profile');
//       }
//     } catch (e) {
//       log('Error fetching profile: $e');
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('โปรไฟล์'),
//       ),
//       body: FutureBuilder<GetProfile>(
//         future: futureProfile,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             GetProfile profile = snapshot.data!;
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: NetworkImage(profile.image),
//                       onBackgroundImageError: (_, __) => const Icon(Icons.error),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildTextField('ชื่อ-นามสกุล', profile.fullname),
//                   _buildTextField('หมายเลขโทรศัพท์', profile.phone),
//                   _buildTextField('อีเมล์', profile.email),
//                   _buildTextField('รูปภาพ', profile.image),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Implement save functionality
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurple,
//                         minimumSize: Size(double.infinity, 50),
//                       ),
//                       child: const Text('บันทึกข้อมูล', style: TextStyle(fontSize: 18)),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(child: Text('No profile data available'));
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildTextField(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//         controller: TextEditingController(text: value),
//         readOnly: false, // Set to false if you want to allow editing
//       ),
//     );
//   }
// }





import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:practice2/config/config.dart';
import 'package:practice2/model/response/get_profile.dart';

class ProfilePage extends StatefulWidget {
  final int idx;

  const ProfilePage({Key? key, required this.idx}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<GetProfile> futureProfile;
  late String url;
  
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
        setState(() {
          futureProfile = fetchProfile();
        });
      },
    );
  }

  Future<GetProfile> fetchProfile() async {
    try {
      final response = await http.get(Uri.parse('$url/customers/${widget.idx}'));

      if (response.statusCode == 200) {
        final profile = getProfileFromJson(response.body);
        _fullnameController.text = profile.fullname;
        _phoneController.text = profile.phone;
        _emailController.text = profile.email;
        _imageController.text = profile.image;
        return profile;
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      log('Error fetching profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfile() async {
    try {
      final response = await http.put(
        Uri.parse('$url/customers/${widget.idx}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': _fullnameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'image': _imageController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      log('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
      ),
      body: FutureBuilder<GetProfile>(
        future: futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            GetProfile profile = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profile.image),
                      onBackgroundImageError: (_, __) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('ชื่อ-นามสกุล', _fullnameController),
                  _buildTextField('หมายเลขโทรศัพท์', _phoneController),
                  _buildTextField('อีเมล์', _emailController),
                  _buildTextField('รูปภาพ', _imageController),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: const Text('บันทึกข้อมูล', style: TextStyle(fontSize: 18 , color: Color.fromARGB(255, 241, 241, 241))),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No profile data available'));
          }
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: controller,
      ),
    );
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}