import 'dart:convert';

import 'package:http/http.dart' as http;
import '../common/model/category.dart';
import 'api_response.dart';

class MaydanServices {
  final String baseURL = "http://192.168.30.131:8000/api/";
  static const int timeOutInSecond = 15;

  Future<ApiResponse<CategoryList>> getCategories() {
    return http
        .get(Uri.parse("${baseURL}categories"))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = CategoryList.getList(jsonData);

          return ApiResponse<CategoryList>(data: list);
        }
        return ApiResponse<CategoryList>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<CategoryList>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<SubCategoryList>> getSubCategories(String categoryId) {
    return http
        .get(Uri.parse("${baseURL}subcategories/category/$categoryId"))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = SubCategoryList.getList(jsonData);

          return ApiResponse<SubCategoryList>(data: list);
        }
        return ApiResponse<SubCategoryList>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<SubCategoryList>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }
}
