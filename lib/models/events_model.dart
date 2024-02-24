class EventsModel {
  String eventId;
  String title;
  String desc;
  String date;
  String address;
  String imgeAssetPath;

  EventsModel(
      {required this.title,
        required this.eventId,
      required this.desc,
      required this.date,
      required this.address,
      required this.imgeAssetPath});
}
