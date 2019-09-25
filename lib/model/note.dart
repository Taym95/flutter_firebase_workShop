class Note {
  String _id;
  String _title;
  String _description;

  Note(this._id, this._title, this._description);

  Note.map(dynamic obj) {
    _id = obj['id'] as String;
    _title = obj['title'] as String;
    _description = obj['description'] as String;
  }

  String get id => _id;
  String get title => _title;
  String get description => _description;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    _id = map['id'].toString();
    _title = map['title'].toString();
    _description = map['description'].toString();
  }
}
