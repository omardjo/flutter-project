import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:teamsyncai/model/reclamation.dart';

class ReclamationService {
 static Future<Map<String, dynamic>> fetchReclamations(String type, String userEmail) async {
  try {
    final response = await http.get(Uri.parse('http://192.168.1.11:3000/reclamation/type/$type?userEmail=$userEmail'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print("Received data: $data");

      List<Reclamation> reclamations = data.map((item) => Reclamation.fromJson(item)).toList();
      int nb = reclamations.length;
      
      return {'reclamations': reclamations, 'count': nb};
    } else {
      print("Failed to load data: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Network error: $e");
    throw Exception('Network error');
  }
}




  static Future<void> deleteReclamation<T extends Reclamation>(
  String id,
  List<T> reclamationList,
  Function setStateCallback,
) async {
  try {
    final url = 'http://192.168.1.11:3000/reclamation/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setStateCallback(() {
        reclamationList.removeWhere((item) => item.id == id);
      });
    } else {
      print('Failed to delete reclamation: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting reclamation: $e');
  }
}



static Future<void> deleteReclamationsByType(
  String type,
  String userEmail,
  List<Reclamation> reclamationList,
  Function setStateCallback,
) async {
  try {
    final url = 'http://192.168.1.11:3000/reclamation/type/$type?userEmail=$userEmail';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setStateCallback(() {
        reclamationList.removeWhere((item) => item.type == type);
      });
    } else {
      print('Failed to delete reclamations by type: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting reclamations by type: $e');
  }
}




static Future<List<Reclamation>> fetchAllReclamations(String userEmail) async {
  final url = 'http://192.168.1.11:3000/reclamation?userEmail=$userEmail';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((reclamation) => Reclamation.fromJson(reclamation)).toList();
  } else {
    throw Exception('Failed to load all reclamations');
  }
}


static Future<List<Reclamation>> getReclamationsForUserManager(String emailManager) async {
  

  final String url = 'http://192.168.1.11:3000/reclamation/manager?emailManager=$emailManager&status=In progress';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((reclamation) => Reclamation.fromJson(reclamation)).toList();
    } else {
      throw Exception('Failed to load reclamations');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}





static Future<void> updateReclamation(String id, Map<String, dynamic> updatedInfoData) async {
  try {
    final url = 'http://192.168.1.11:3000/reclamation/$id'; // Assurez-vous que $id est correctement remplacé par l'ID réel
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedInfoData),
    );

    if (response.statusCode == 200) {
      print('Reclamation updated successfully');
    } else {
      print('Failed to update reclamation: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating reclamation: $e');
  }
}

}