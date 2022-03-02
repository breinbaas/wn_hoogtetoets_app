class DataDike {
  final double lon;
  final double lat;
  final double z_ahn4;
  final double bgs;
  final double z_req;


  DataDike(
      {this.lat, this.lon, this.z_ahn4, this.bgs, this.z_req});
  factory DataDike.fromJson(Map<String, dynamic> json) => DataDike(
      lat: json['lat'],
      lon: json['lon'],
      z_ahn4: json['z_ahn4'],
      bgs: json['bgs'],
      z_req: json['z_req']);
  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        'z_ahn4': z_ahn4,
        'bgs': bgs,
        'z_req': z_req
      };
}
