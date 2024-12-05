import 'package:asar/features/events/domain/entities/event.dart';

class EventModel extends Event {
  EventModel({
    required super.eventId,
    required super.title,
    required super.oneLinerTitle,
    required super.iconUrl,
    required super.currentYesPrice,
    required super.currentNoPrice,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['_id'] as String,
      title: json['title'] as String,
      oneLinerTitle: json['one_liner_title'] as String,
      iconUrl: json['icons'] as String,
      currentYesPrice: json['currentYesPrice'] as num,
      currentNoPrice: json['currentNoPrice'] as num,
    );
  }


  EventModel copyWith({
    String? eventId,
    String? title,
    String? oneLinerTitle,
    String? iconUrl,
    double? currentYesPrice,
    double? currentNoPrice,
  }) {
    return EventModel(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      oneLinerTitle: oneLinerTitle ?? this.oneLinerTitle,
      iconUrl: iconUrl ?? this.iconUrl,
      currentYesPrice: currentYesPrice ?? this.currentYesPrice ,
      currentNoPrice: currentNoPrice ?? this.currentNoPrice,
    );
  }

  @override
  String toString() {
    return 'EventModel(eventId: $eventId, title: $title, oneLinerTitle: $oneLinerTitle, iconUrl: $iconUrl, currentYesPrice: $currentYesPrice, currentNoPrice: $currentNoPrice)';
  }
}
