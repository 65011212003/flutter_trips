// To parse this JSON data, do
//
//     final customerCreatePostResponse = customerCreatePostResponseFromJson(jsonString);

import 'dart:convert';

CustomerCreatePostResponse customerCreatePostResponseFromJson(String str) => CustomerCreatePostResponse.fromJson(json.decode(str));

String customerCreatePostResponseToJson(CustomerCreatePostResponse data) => json.encode(data.toJson());

class CustomerCreatePostResponse {
    String message;
    int id;

    CustomerCreatePostResponse({
        required this.message,
        required this.id,
    });

    factory CustomerCreatePostResponse.fromJson(Map<String, dynamic> json) => CustomerCreatePostResponse(
        message: json["message"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
    };
}