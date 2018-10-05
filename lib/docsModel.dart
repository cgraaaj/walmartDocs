// class DocsModel {
//   final int id;
//   final String title;
//   DocsModel({
//     this.id,
//     this.title
//   });
//   factory DocsModel.fromJson(Map<String,dynamic> json)
//   {
//     return DocsModel(id:json['id'] as int,
//     title:json['title']as String);
//   }

// }
class DocsModel {
   List<Data> data;

  DocsModel({this.data});

   List<Data> fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String title;


  Data({this.id, this.title});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
