
class MyLogger{
  String name;
  String path;
  DateTime date;
  MyLogger(this.name,this.path,):date=DateTime.now();
  log(String info){
    print("${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute}:${date.second} [ $name ] : $info");
  }
  logErr(String err){
    print("${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute}:${date.second} [ $name ] : $err");
  }
}