class Room1Model{
  String? uid;
  String? time;
  String? message;


  Room1Map() {
    var mapping = Map<String, dynamic>();
    mapping['uid']=uid;
    mapping['time'] = time;
    mapping['message'] = message;
    return mapping;
  }

}