class ApiConstants {
  static const String baseUrl = 'https://alcohol.bada.works/api';

  // GET endpoints
  static const String drinks = '$baseUrl/drinks/?format=json';
  static const String bases = '$baseUrl/bases/?format=json';

  // POST endpoints
  static const String postDrink = '$baseUrl/postdrink/';
  static const String postBase = '$baseUrl/postbase/';
  static const String postRecipe = '$baseUrl/postrecipe/';
  static const String comments = '$baseUrl/comments/';

  // Dynamic endpoints
  static String updateBase(int idx) => '$baseUrl/postbase/$idx/';
  static String updateRecipe(int idx) => '$baseUrl/postrecipe/$idx/';
  static String deleteRecipe(int idx) => '$baseUrl/postrecipe/$idx/';
  static String deleteComment(int idx) => '$baseUrl/comments/$idx/';
  static String drinkComments(int drinkIdx) => '$baseUrl/comments/?search=$drinkIdx';
  static String uploadImage(int drinkIdx) => '$baseUrl/upload-image/$drinkIdx/';
}
