import 'dart:convert';

import 'package:http/http.dart' as http;

class RazorpayApiService {
  static Future<String?> getRazorPayApi(int amount) async {
    var jsonEncodeData = {
      "amount": "$amount",
      "currency": "INR",
      "receipt": "Receipt no. 1",
      "notes": {
        "notes_key_1": "Tea, Earl Grey, Hot",
        "notes_key_2": "Tea, Earl Grey… decaf.",
      },
    };
    var basicAuth =
        'Basic ' +
            base64Encode(
              utf8.encode('rzp_test_RuGkfl8jgd5hXl:TkADZiPE0Yrw43WQrFtML3Gi'),
            );
    var response = await http.post(
      Uri.parse("https://api.razorpay.com/v1/orders"),
      body: jsonEncode(jsonEncodeData),
      headers: {"authorization": basicAuth},
    );

    if (response.statusCode == 200) {
      var resBody = response.body;
      dynamic jsonBody = jsonDecode(resBody);
      var dataId = jsonBody["id"];
      return dataId;
    }
    return null;
  }
}
