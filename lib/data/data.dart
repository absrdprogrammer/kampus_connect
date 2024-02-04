import 'package:kampus_connect/models/date_model.dart';
import 'package:kampus_connect/models/event_type_model.dart';
import 'package:kampus_connect/models/events_model.dart';

List<DateModel> dates = [
  DateModel(weekDay: "Sun", date: "10"),
  DateModel(weekDay: "Mon", date: "11"),
  DateModel(weekDay: "Tue", date: "12"),
  DateModel(weekDay: "Wed", date: "13"),
  DateModel(weekDay: "Thu", date: "14"),
  DateModel(weekDay: "Fri", date: "15"),
  DateModel(weekDay: "Sat", date: "16")
];

List<EventTypeModel> eventTypes = [
  EventTypeModel(
      imgAssetPath: "assets/images/hello-image", eventType: "Festival"),
  EventTypeModel(
      imgAssetPath: "assets/images/hello-image", eventType: "Festival"),
  EventTypeModel(
      imgAssetPath: "assets/images/hello-image", eventType: "Festival"),
];

List<EventsModel> events = [
  EventsModel(address: "Greenfields, Sector 42, Faridabad", imgeAssetPath: "assets/images/hello-image", desc: "Sports Meet in Galaxy Field", date: "Jan 12, 2019")
];

// List<EventTypeModel> getEventTypes() {
//   List<EventTypeModel> events = new List();
//   EventTypeModel eventModel = new EventTypeModel();

//   //1
//   eventModel.imgAssetPath = "assets/concert.png";
//   eventModel.eventType = "Concert";
//   events.add(eventModel);

//   eventModel = new EventTypeModel();

//   //1
//   eventModel.imgAssetPath = "assets/sports.png";
//   eventModel.eventType = "Sports";
//   events.add(eventModel);

//   eventModel = new EventTypeModel();

//   //1
//   eventModel.imgAssetPath = "assets/education.png";
//   eventModel.eventType = "Education";
//   events.add(eventModel);

//   eventModel = new EventTypeModel();

//   return events;
// }

// List<EventsModel> getEvents() {
//   List<EventsModel> events = new List<EventsModel>();
//   EventsModel eventsModel = new EventsModel();

//   //1
//   eventsModel.imgeAssetPath = "assets/tileimg.png";
//   eventsModel.date = "Jan 12, 2019";
//   eventsModel.desc = "Sports Meet in Galaxy Field";
//   eventsModel.address = "Greenfields, Sector 42, Faridabad";
//   events.add(eventsModel);

//   eventsModel = new EventsModel();

//   //2
//   eventsModel.imgeAssetPath = "assets/second.png";
//   eventsModel.date = "Jan 12, 2019";
//   eventsModel.desc = "Art & Meet in Street Plaza";
//   eventsModel.address = "Galaxyfields, Sector 22, Faridabad";
//   events.add(eventsModel);

//   eventsModel = new EventsModel();

//   //3
//   eventsModel.imgeAssetPath = "assets/music_event.png";
//   eventsModel.date = "Jan 12, 2019";
//   eventsModel.address = "Galaxyfields, Sector 22, Faridabad";
//   eventsModel.desc = "Youth Music in Gwalior";
//   events.add(eventsModel);

//   eventsModel = new EventsModel();

//   return events;
// }
