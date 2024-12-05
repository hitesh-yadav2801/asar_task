class Event {
  final String eventId;
  final String title;
  final String oneLinerTitle;
  final String iconUrl;
  final num currentYesPrice;
  final num currentNoPrice;

  Event({
    required this.eventId,
    required this.title,
    required this.oneLinerTitle,
    required this.iconUrl,
    required this.currentYesPrice,
    required this.currentNoPrice,
  });
}
