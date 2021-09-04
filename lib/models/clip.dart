class Clip {
  String? clipId;
  String? clipLink;
  String? clipTitle;

  Clip({
    this.clipId,
    this.clipTitle,
    this.clipLink,
  });

  factory Clip.fromJson(dynamic json) => Clip(
        clipId: json['clip_id'],
        clipTitle: json['clip_title'],
        clipLink: json['clip_link'],
      );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['clip_id'] = clipId;
    map['clip_title'] = clipTitle;
    map['clip_link'] = clipLink;
    return map;
  }
}
