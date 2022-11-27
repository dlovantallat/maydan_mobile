import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../common/model/category.dart';
import 'api_response.dart';

class MaydanServices {
  final String baseURL = "http://192.168.30.131:8000/api/";
  static const int timeOutInSecond = 15;

  Future<ApiResponse<List<CategoryData>>> getCategories() {
    return http
        .get(Uri.parse("${baseURL}categories"))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          List<CategoryData> l = [];
          for (var i in jsonData) {
            l.add(CategoryData.fromJson(i));
          }

          return ApiResponse<List<CategoryData>>(data: l);
        }
        return ApiResponse<List<CategoryData>>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<List<CategoryData>>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }
}
