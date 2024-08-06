// To parse this JSON data, do
//
//     final imagesResponse = imagesResponseFromJson(jsonString);

import 'dart:convert';

ImagesResponse imagesResponseFromJson(String str) => ImagesResponse.fromJson(json.decode(str));

String imagesResponseToJson(ImagesResponse data) => json.encode(data.toJson());

class ImagesResponse {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    ImagesResponse({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory ImagesResponse.fromJson(Map<String, dynamic> json) => ImagesResponse(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}