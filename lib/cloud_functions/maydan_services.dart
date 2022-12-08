import 'dart:convert';

import 'package:http/http.dart' as http;
import '../common/model/category.dart';
import '../common/model/item.dart';
import 'api_response.dart';

class MaydanServices {
  final String baseURL = "https://maydan.farm/maydan_api/public/api/mobile/";
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
        .get(Uri.parse("${baseURL}categories/$categoryId/subcategories"))
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

  Future<ApiResponse<ItemList>> getItems(String subCategoryId) {
    return http
        .get(Uri.parse("${baseURL}items/subcategory/$subCategoryId"))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemList.getList(jsonData);

          return ApiResponse<ItemList>(data: list);
        }
        return ApiResponse<ItemList>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemList>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }
}
