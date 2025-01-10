import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_algo/ml_algo.dart';

// Equipment class definition
class Equipment {
  final int id;
  final String name;
  final String type;
  final DateTime lastMaintenanceDate;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.lastMaintenanceDate,
  });

  // Convert an Equipment object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
    };
  }

  // Create an Equipment object from a Map object
  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      lastMaintenanceDate: DateTime.parse(map['lastMaintenanceDate']),
    );
  }
}

// Encryption utility class
class EncryptionUtil {
  final Key key;
  final IV iv;

  EncryptionUtil(this.key, this.iv);

  // Encrypt data
  String encrypt(String data) {
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(data, iv: iv).base64;
  }

  // Decrypt data
  String decrypt(String encryptedData) {
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt64(encryptedData, iv: iv);
  }
}

// Data processing class
class DataProcessor {
  final List<Equipment> equipmentList;
  final EncryptionUtil encryptionUtil;

  DataProcessor(this.equipmentList, this.encryptionUtil);

  // Process equipment data
  void processEquipmentData() {
    for (var equipment in equipmentList) {
      try {
        // Encrypt equipment data
        String encryptedData = encryptionUtil.encrypt(jsonEncode(equipment.toMap()));
        print('Encrypted Equipment Data: $encryptedData');

        // Simulate anomaly detection
        detectAnomalies(equipment);
      } catch (e) {
        print('Error processing equipment ${equipment.id}: $e');
      }
    }
  }

  // Simple anomaly detection logic
  void detectAnomalies(Equipment equipment) {
    // Placeholder for anomaly detection logic
    // In a real application, you would implement a machine learning model here
    if (equipment.lastMaintenanceDate.isBefore(DateTime.now().subtract(Duration(days: 365)))) {
      print('Anomaly detected for equipment ${equipment.id}: Maintenance overdue!');
    }
  }
}

// Socket server for communication
class EquipmentServer {
  final int port;
  late ServerSocket serverSocket;

  EquipmentServer(this.port);

  // Start the server
  Future<void> start() async {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print('Server started on port $port');

    await for (var socket in serverSocket) {
      handleClient(socket);
    }
  }

  // Handle incoming client connections
  void handleClient(Socket client) {
    print('Client connected: ${client.remoteAddress.address}:${client.remotePort}');
    client.listen((data) {
      String message = String.fromCharCodes(data);
      print('Received: $message');
      client.write('Echo: $message');
    }, onDone: () {
      print('Client disconnected: ${client.remoteAddress.address}:${client.remotePort}');
      client.close();
    });
  }
}

//
