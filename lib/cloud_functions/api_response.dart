class ApiResponse<T> {
  T? data;
  bool requestStatus;
  String errorMessage;
  int statusCode;

  ApiResponse({
    this.data,
    this.requestStatus = false,
    this.errorMessage = "",
    this.statusCode = -1,
  });
}
