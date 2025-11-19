import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'MosAPI.dart';
import 'MosData.dart';
import 'user_Page.dart';

final api = MosAPI();

class MainPage extends StatefulWidget {
  @override
  _Main_Page createState() => _Main_Page();
}

class _Main_Page extends State<MainPage> {
  MosData? mosquitoData;
  bool isLoading = true;

  String selectedImgUrlHouse = '';
  String selectedImgUrlWater = '';
  String selectedImgUrlPark = '';
  String selectedColorHouse = '';
  String selectedColorWater = '';
  String selectedColorPark = '';
  String selectedImgUrlMean = '';
  String selectedColorMean = '';
  var mosMean;

  var mosImgList = ["images/middle.png", "images/yello.png", "images/red.png"];
  List<String> colors = ['0xfff95DB94', '0xfffFFC178', '0xfffF97777'];

  var url = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    MosAPI api = MosAPI();
    try {
      var data = await api.fetchNew(date); // API 호출 결과를 임시 변수에 저장
      if (mounted) {
        setState(() {
          mosquitoData = data;
          isLoading = false;
          if (mosquitoData != null) {
            _mosMeanImg();
            selectImgAndColor(mosMean, 'mean');
            selectImgAndColor(mosquitoData!.valueHouse, 'house');
            selectImgAndColor(mosquitoData!.valueWater, 'water');
            selectImgAndColor(mosquitoData!.valuePark, 'park');
          }
        });
      }
    } catch (e) {
      // 에러 처리 (필요 시)
      print("Error fetching data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _mosMeanImg() {
    if (mosquitoData == null) return;
    mosMean = (mosquitoData!.valueWater +
        mosquitoData!.valueHouse +
        mosquitoData!.valuePark) /
        3;
    if (mosMean <= 25) {
      url = "${mosImgList[0]}";
    } else if (25 < mosMean && mosMean <= 75) {
      url = "${mosImgList[1]}";
    } else {
      url = "${mosImgList[2]}";
    }
  }

  void selectImgAndColor(double mosquitoValue, String mosquitoType) {
    int index;
    if (mosquitoValue <= 25) {
      index = 0;
    } else if (mosquitoValue <= 75) {
      index = 1;
    } else {
      index = 2;
    }
    switch (mosquitoType) {
      case 'house':
        selectedImgUrlHouse = mosImgList[index];
        selectedColorHouse = colors[index];
        break;
      case 'water':
        selectedImgUrlWater = mosImgList[index];
        selectedColorWater = colors[index];
        break;
      case 'park':
        selectedImgUrlPark = mosImgList[index];
        selectedColorPark = colors[index];
        break;
      case 'mean':
        selectedColorMean = colors[index];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EA),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : mosquitoData == null
            ? const Center(child: Text("데이터를 불러올 수 없습니다."))
            : SingleChildScrollView(
          // [수정 2] 스크롤 가능하도록 감싸기
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양옆 여백 추가
            child: Column(
              children: [
                // 상단 헤더 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Today mosquito",
                        style: TextStyle(
                          color: Color(0xff815B5B),
                          fontFamily: "Schyler",
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => user_Page()),
                          );
                        },
                        child: ClipOval(
                          child: Image.asset(
                            "images/playstore.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20), // 간격 추가

                // 메인 카드 영역
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        // 평균 지수 및 이미지
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "오늘의 모기 지수",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(mosquitoData!.date),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              ((mosquitoData!.valueWater +
                                  mosquitoData!.valueHouse +
                                  mosquitoData!.valuePark) /
                                  3)
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                  color: Color(
                                      int.parse(selectedColorMean)),
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Image.asset(
                              url,
                              width: 120,
                              height: 120,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 주거지, 공원, 수변지 리스트
                        _buildMosquitoRow("주거지", mosquitoData!.valueHouse,
                            selectedColorHouse, selectedImgUrlHouse),
                        _buildMosquitoRow("공원", mosquitoData!.valuePark,
                            selectedColorPark, selectedImgUrlPark),
                        _buildMosquitoRow("수변지", mosquitoData!.valueWater,
                            selectedColorWater, selectedImgUrlWater),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegend(const Color(0xffff97777), "모기위험", "76 ~ 100"),
                            _buildLegend(const Color(0xfffFFC178), "모기주의", "26 ~ 75"),
                            _buildLegend(const Color(0xfff95DB94), "모기안전", "0 ~ 25"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMosquitoRow(String title, double value, String colorCode, String imgPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(title,
                style: const TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Color(int.parse(colorCode)),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Image.asset(
            imgPath,
            width: 80,
            height: 80,
          )
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label, String range) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            const SizedBox(width: 5),
            Text(label)
          ],
        ),
        Text(range)
      ],
    );
  }
}