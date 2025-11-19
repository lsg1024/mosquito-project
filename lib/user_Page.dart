import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class user_Page extends StatefulWidget {
  const user_Page({super.key});

  @override
  _user_Page createState() {
    return _user_Page();
  }
}

class _user_Page extends State<user_Page> {
  TimeOfDay? _selectedTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> sendDataToServer(TimeOfDay? selectedTime) async {

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 알림 시간을 설정해주세요.')),
      );
      return;
    }

    final String formattedTime =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

    String? deviceToken = await getDeviceToken();

    if (deviceToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('디바이스 토큰을 가져오는 데 실패했습니다.')),
      );
      return;
    }

    try {
      // Firestore 'scheduledTokens' 컬렉션에 토큰을 ID로 사용하여 데이터 저장/덮어쓰기
      await _firestore.collection('scheduledTokens').doc(deviceToken).set({
        'token': deviceToken,
        'time': formattedTime,
        'updatedAt': FieldValue.serverTimestamp(), // 저장 시간 기록
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('알림이 $formattedTime 에 설정되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('알림 설정에 실패했습니다: $e')),
      );
    }
  }

  Future<void> delData() async {
    String? deviceToken = await getDeviceToken();

    if (deviceToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('디바이스 토큰을 가져오는 데 실패했습니다.')),
      );
      return;
    }

    try {
      await _firestore.collection('scheduledTokens').doc(deviceToken).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('알림이 중지되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('알림 중지에 실패했습니다: $e')),
      );
    }
  }

  // 디바이스 토큰 추출
  Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 20),
            child: Text(
              "Mosquito Alarm",
              style: TextStyle(
                color: Color(0xff815B5B),
                fontFamily: "Schyler",
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 5,
                    child: Container(
                      width: 360,
                      height: 500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 20),
                            child: Text(
                              _selectedTime == null
                                  ? "알림 시간을 설정해주세요"
                                  : "선택한 알람 시간 : ${_selectedTime!.format(context)}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 60),
                                    child: SizedBox(
                                        height: 50,
                                        width: 300,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              WidgetStateProperty.all(
                                                  const Color(0xff674949))),
                                          onPressed: () => _selectTime(context),
                                          child: const Text(
                                            "알림 시간 설정",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))),
                                Padding(
                                    padding: const EdgeInsets.only(top: 60),
                                    child: SizedBox(
                                        height: 50,
                                        width: 300,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              WidgetStateProperty.all(
                                                  const Color(0xff674949))),
                                          onPressed: () async {
                                            sendDataToServer(_selectedTime);
                                          },
                                          child: const Text(
                                            "알림 설정 완료",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))),
                                Padding(
                                    padding: const EdgeInsets.only(top: 60),
                                    child: SizedBox(
                                        height: 50,
                                        width: 300,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              WidgetStateProperty.all(
                                                  const Color(0xffff4141))),
                                          onPressed: () async {
                                            delData();
                                          },
                                          child: const Text(
                                            "알림 중지",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}