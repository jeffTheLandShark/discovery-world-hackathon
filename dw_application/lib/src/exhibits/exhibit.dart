class ExhibitMapEntry {
  const ExhibitMapEntry(this.id, this.location);
  ExhibitMapEntry.withLocation(this.id, x, y, layer)
      : location = Location(x, y, layer);

  final int id;
  final Location location;

  // plotting information
  final String icon = 'assets/images/exhibit_icon.png';
  final int color = 0xFF000000;
  final double size = 20.0;
}

class Location {
  const Location(this.x, this.y, this.layer);

  final double x;
  final double y;
  final double layer;
}

class Exhibit {
  const Exhibit(this.id, this.image, this.article, this.languageCode,
      this.difficultyLevel);

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

  final int id;
  final Map<String, String> titles;
  final Map<String, String> descriptions;

  String getTitle(String lookupCode) {
    return titles[lookupCode] ?? titles['en1'] ?? '';
  }

  String getDescription(String lookupCode) {
    return descriptions[lookupCode] ?? descriptions['en1'] ?? '';
  }
}
