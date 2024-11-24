class ExhibitMapEntry {
  const ExhibitMapEntry(this.id, this.location, this.description);
  ExhibitMapEntry.withLocation(this.id, x, y, layer, this.description)
      : location = Location(x, y, layer);

  factory ExhibitMapEntry.fromJson(Map<String, dynamic> json) {
    return ExhibitMapEntry.withLocation(
        json['id'] as String,
        json['x'] as int,
        json['y'] as int,
        json['layer'] as int,
        json['description'] as String);
  }

  final String id;
  final Location location;
  final String description;

  // plotting information
  final String icon = 'assets/images/exhibit_icon.png';
  final int color = 0xFF000000;
  final double size = 20.0;
}

class Location {
  const Location(this.x, this.y, this.layer);

  final int x;
  final int y;
  final int layer;
}

class Exhibit {
  const Exhibit(this.id, this.image, this.article);

  Exhibit.blank()
      : id = '',
        image = '',
        article = Article('', {}, {});

  factory Exhibit.fromJson(Map<String, dynamic> json) {
    return Exhibit(
        json['id'] as String,
        json['image'] as String,
        Article(
          json['article']['id'] as String,
          Map<String, String>.from(json['article']['titles'] as Map),
          Map<String, String>.from(
              json['article']['descriptions'] as Map<String, dynamic>),
        ));
  }

  final String id;
  final String image;
  final Article article;

  String getTitle({language = 'en'}) {
    return article.getTitle('$language' '1');
  }

  String getDescription({language = 'en', difficultyLevel = '1'}) {
    return article.getDescription(language, difficultyLevel);
  }

  bool hasContent(String content, {String language = 'en'}) {
    return article.hasContent(content, language: language);
  }
}

class Article {
  const Article(this.id, this.titles, this.descriptions);

  final String id;
  final Map<String, String> titles;
  final Map<String, String> descriptions;

  String getTitle(String language) {
    return titles[language] ?? titles['en'] ?? '';
  }

  String getDescription(String language, String difficultyLevel) {
    final lookupCode = '$language$difficultyLevel';
    return descriptions[lookupCode] ??
        descriptions['$language' '1'] ??
        descriptions['en1'] ??
        '';
  }

  bool hasContent(String content, {String language = 'en'}) {
    // checks all difficulty levels for desciptions and titles in that language
    return descriptions.values
            .where((element) => element.contains(content))
            .isNotEmpty ||
        titles.values.where((element) => element.contains(content)).isNotEmpty;
  }
}
