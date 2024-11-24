class ExhibitMapEntry {
  const ExhibitMapEntry(this.id, this.location, this.description);
  ExhibitMapEntry.withLocation(this.id, x, y, layer, this.description)
      : location = Location(x, y, layer);

  final int id;
  final Location location;
  final String description;

  // plotting information
  final String icon = 'assets/images/exhibit_icon.png';
  final int color = 0xFF000000;
  final double size = 20.0;
}

class Location {
  const Location(this.x, this.y, this.layer);

  final double x;
  final double y;
  final int layer;
}

class Exhibit {
  const Exhibit(this.id, this.image, this.article, this.languageCode,
      this.difficultyLevel);

  Exhibit.blank()
      : id = '',
        image = '',
        article = Article('', {}, {}),
        languageCode = '',
        difficultyLevel = '';
        

  factory Exhibit.fromJson(Map<String, dynamic> json) {
    return Exhibit(
      json['id'] as String,
      json['image'] as String,
      Article(
        json['article']['id'] as String,
        Map<String, String>.from(json['article']['titles'] as Map),
        Map<String, String>.from(
            json['article']['descriptions'] as Map<String, dynamic>),
      ),
      json['languageCode'] as String,
      json['difficultyLevel'] as String,
    );
  }

  final String id;
  final String image;
  final Article article;
  final String languageCode;
  final String difficultyLevel;

  String getTitle() {
    return article.getTitle(languageCode + difficultyLevel);
  }

  String getDescription() {
    return article.getDescription(languageCode + difficultyLevel);
  }
}

class Article {
  const Article(this.id, this.titles, this.descriptions);

  final String id;
  final Map<String, String> titles;
  final Map<String, String> descriptions;

  String getTitle(String lookupCode) {
    return titles[lookupCode] ?? titles['en1'] ?? '';
  }

  String getDescription(String lookupCode) {
    return descriptions[lookupCode] ?? descriptions['en1'] ?? '';
  }
}
