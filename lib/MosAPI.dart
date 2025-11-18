import 'package:http/http.dart' as http;
import 'dart:convert';
import 'MosData.dart';

class MosAPI {
  final String baseUrl =
      "http://openapi.seoul.go.kr:8088/777876567a736b3038396f754c4658/json/MosquitoStatus/1/2";

  MosAPI();

  Future<MosData?> fetchNew(String date) async {
    DateTime currentDateTime = DateTime.parse(date);
    MosData? mosquitoData;

    while (mosquitoData == null) {
      final String requestUrl = '$baseUrl/${currentDateTime.toIso8601String().split("T")[0]}';
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        if (decodedResponse.containsKey('MosquitoStatus')) {
          var rowData = decodedResponse['MosquitoStatus']['row'][0];
          mosquitoData = MosData(
            date: rowData['MOSQUITO_DATE'],
            valueWater: double.parse(rowData['MOSQUITO_VALUE_WATER']),
            valueHouse: double.parse(rowData['MOSQUITO_VALUE_HOUSE']),
            valuePark: double.parse(rowData['MOSQUITO_VALUE_PARK']),
          );
        } else if (decodedResponse.containsKey('RESULT') &&
            decodedResponse['RESULT']['MESSAGE'] == '해당하는 데이터가 없습니다.') {
          currentDateTime = currentDateTime.subtract(const Duration(days: 1));
        } else {
          throw Exception("Unknown Error");
        }
      } else {
        throw Exception("Failed to Mos");
      }
    }
    return mosquitoData;
  }
}
