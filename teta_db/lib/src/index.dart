library teta_no_sql;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

part 'components/database.dart';
part 'components/realtime.dart';
part 'components/utils.dart';
part 'models/no_sql_stream.dart';
part 'models/socket_change_event.dart';

const String _host = 'builder.teta.so';
const String _port = '9840';

const String _baseUrl = 'https://$_host:$_port';
