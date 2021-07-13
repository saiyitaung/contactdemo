const String DB = "contactdb";

String fmtTime(int? time) {
  var t = DateTime.fromMillisecondsSinceEpoch(time!);
  return "${monthShort[t.month - 1]} ${t.day},${t.year}";
}

List<String> monthShort = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

bool matchPhoneNumber(String ph) {
  if (ph.startsWith(RegExp("^09")) && (ph.length > 8 && ph.length < 12)) {
    return true;
  }
  return false;
}

// bool isToday(int time) {
//   DateTime d = DateTime.fromMillisecondsSinceEpoch(time);
//   DateTime now = DateTime.now();
//   if (d.day == now.day && d.month == now.month && d.year == now.year) {
//     return true;
//   }
//   return false;
// }
