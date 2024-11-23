import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';

class ExhibitSearchPage extends StatefulWidget {
  @override
  _ExhibitSearchPageState createState() => _ExhibitSearchPageState();
}

class _ExhibitSearchPageState extends State<ExhibitSearchPage> {
  late Exhibit exhibit;

  @override
  void initState() {
    super.initState();
    loadExhibitData();
  }

  void loadExhibitData() {
    String jsonData = '''
    {
      "Exhibit1": {
          "Exhibit_ID": "1",
          "Exhibit_Display_Name": "Lorem",
          "Exhibit_Image_Path": "img/example",
          "Map_Location": "S123",
          "Article": [
              {
                  "Language": "English",
                  "Difficulty": 1,
                  "Body": "Loreme"
              },
              {
                  "Language": "English",
                  "Difficulty": 2,
                  "Body": "Loreme"
              },
              {
                  "Language": "English",
                  "Difficulty": 3,
                  "Body": "Loreme"
              },
              {
                  "Language": "Spanish",
                  "Difficulty": 1,
                  "Body": "Lorems"
              },
              {
                  "Language": "Hmong",
                  "Difficulty": 1,
                  "Body": "Loremh"
              }
          ]
      }
    }
    ''';

    Map<String, dynamic> jsonMap = json.decode(jsonData);
    setState(() {
      exhibit = Exhibit.fromJson(jsonMap['Exhibit1']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Exhibits'),
      ),
      body: exhibit != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchableList<Exhibit>(
                builder: (exhibit) => ListTile(
                  title: Text(exhibit.exhibitDisplayName),
                  subtitle: Text('Location: ${exhibit.mapLocation}'),
                ),
                errorWidget: Text('No exhibit found'),
                emptyWidget: Text('No data available'),
                onSearch: (String search) {
                  List<Exhibit> results = [];
                  // Searching based on exhibit name and article body
                  if (exhibit.exhibitDisplayName.toLowerCase().contains(search.toLowerCase())) {
                    results.add(exhibit);
                  } else {
                    for (Article article in exhibit.articles) {
                      if (article.body.toLowerCase().contains(search.toLowerCase())) {
                        results.add(exhibit);
                        break;
                      }
                    }
                  }
                  return results;
                },
                displayClearIcon: true,
                items: [exhibit],
                searchHintText: 'Search exhibits...',
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ExhibitSearchPage(),
  ));
}