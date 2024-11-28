import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = '8c1067c7c018454fa3f9a8061907a789'; // Заміни на свій ключ API
  final String apiUrl = 'https://newsapi.org/v2/everything';

  Future<List<String>> fetchEducationalNews() async {
    try {
      // Виконуємо запит до API
      final response = await http.get(Uri.parse('$apiUrl?q=education&apiKey=$apiKey'));

      if (response.statusCode == 200) {
        // Розбираємо відповідь
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

        // Виводимо відповідь для перевірки
        print('Response: $data');

        // Перевіряємо, чи існує ключ 'articles' і чи є він списком
        if (data.containsKey('articles') && data['articles'] is List) {
          List<String> newsTitles = [];

          // Безпечно проходимо по списку 'articles'
          List<dynamic> articles = data['articles'] as List<dynamic>;
          for (var article in articles) {
            // Перевіряємо, чи є стаття Map і містить ключ 'title'
            if (article is Map<String, dynamic> && article.containsKey('title')) {
              newsTitles.add(article['title'] as String); // Переконуємося, що 'title' це String
            }
          }

          return newsTitles;
        } else {
          throw Exception('No articles found in the response or incorrect format');
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch educational news: $e');
    }
  }
}
