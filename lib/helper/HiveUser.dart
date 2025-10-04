import 'package:hive/hive.dart';

part 'HiveUser.g.dart'; 

@HiveType(typeId: 0) 
class HiveUser {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  HiveUser({required this.email, required this.password});
}