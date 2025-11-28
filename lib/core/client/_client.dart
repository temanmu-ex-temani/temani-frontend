import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:temanmu/services/shared_preference_service.dart';

import '../../services/depedencies/di.dart';
import '../../services/logger_service.dart';
import '../errors/failure.dart';

part 'dio.dart';
part 'api_call.dart';
