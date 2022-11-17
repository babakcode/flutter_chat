class AppConfig{
  AppConfig._();


  static double get radiusCircular => 20;

  /// sandbox url
  // static String get baseUrl => 'http://181.41.194.157:50001/api';
  // static String get socketBaseUrl => 'http://181.41.194.157:50001/';

  /// localhost
  // static String get baseUrl => 'http://localhost:50001/api';
  // static String get socketBaseUrl => 'http://localhost:50001/';

  // localhost 2
  static String get baseUrl => 'http://192.168.1.173:50001/api';
  static String get socketBaseUrl => 'http://192.168.1.173:50001/';

  // localhost 3
  // static String get baseUrl => 'http://192.168.1.173:50001/api';
  // static String get socketBaseUrl => 'http://192.168.1.173:50001/';


  static String get globalEncryptKey => 'jwudownwaodw21ewje2elq2ekwamkwda';

}