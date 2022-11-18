import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/models/app_collection.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/room.dart';

class HiveManager{


  final _roomBox = Hive.box<Map>('room');
  // final _usersBox = Hive.box('user');
  // final _chatsBox = Hive.box('chat');

  addAllRooms(List<Room> rooms){
    // for(var room in rooms){
    //   _roomBox.put(room.id, room.toMap());
    // }

  }

  getAllRooms(){

  }



}
