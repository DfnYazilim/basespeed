class IspnModel {
  IspnModel({
      this.url, 
      this.lat, 
      this.lon, 
      this.distance, 
      this.name, 
      this.country, 
      this.cc, 
      this.sponsor, 
      this.id, 
      this.preferred, 
      this.httpsFunctional, 
      this.host, 
      this.forcePingSelect,});

  IspnModel.fromJson(dynamic json) {
    url = json['url'];
    lat = json['lat'];
    lon = json['lon'];
    distance = json['distance'];
    name = json['name'];
    country = json['country'];
    cc = json['cc'];
    sponsor = json['sponsor'];
    id = json['id'];
    preferred = json['preferred'];
    httpsFunctional = json['https_functional'];
    host = json['host'];
    forcePingSelect = json['force_ping_select'];
  }
  String? url;
  String? lat;
  String? lon;
  int? distance;
  String? name;
  String? country;
  String? cc;
  String? sponsor;
  String? id;
  int? preferred;
  int? httpsFunctional;
  String? host;
  int? forcePingSelect;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['lat'] = lat;
    map['lon'] = lon;
    map['distance'] = distance;
    map['name'] = name;
    map['country'] = country;
    map['cc'] = cc;
    map['sponsor'] = sponsor;
    map['id'] = id;
    map['preferred'] = preferred;
    map['https_functional'] = httpsFunctional;
    map['host'] = host;
    map['force_ping_select'] = forcePingSelect;
    return map;
  }

}