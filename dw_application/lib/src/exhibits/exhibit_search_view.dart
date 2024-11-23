import 'package:flutter/material.dart';
import 'exhibit.dart';


class ExhibitSearchView extends StatefulWidget {
  const ExhibitSearchView({super.key, required this.exhibits});
  static const routeName = '/exhibit_search';
  final List<Exhibit> exhibits;

  @override
  State<ExhibitSearchView> createState() => _ExhibitSearchViewState();
}

class _ExhibitSearchViewState extends State<ExhibitSearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}