import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';

final _dioInstance = Dio();

Dio get dioInstance => _dioInstance;

LocalStorage get localStorage => LocalStorage('session_data');
