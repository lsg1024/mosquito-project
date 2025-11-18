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


class _Main_Page extends State<MainPage>{

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

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  // 모기 데이터의 평균, 주거지, 수변지, 공원 부분 데이터 호출
  Future<void> fetchData() async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    MosAPI api = MosAPI();
    mosquitoData = await api.fetchNew(date);

    setState(() {
      isLoading = false;
      _mosMeanImg();
      if (mosquitoData != null) {
        selectImgAndColor(mosMean, 'mean');
        selectImgAndColor(mosquitoData!.valueHouse, 'house');
        selectImgAndColor(mosquitoData!.valueWater, 'water');
        selectImgAndColor(mosquitoData!.valuePark, 'park');
      }
    });
  }

  var mosImgList = ["images/middle.png", "images/yello.png", "images/red.png"];
  List<String> colors = ['0xfff95DB94', '0xfffFFC178', '0xfffF97777'];

  var url = "";

  void _mosMeanImg() {
    mosMean = (mosquitoData!.valueWater + mosquitoData!.valueHouse + mosquitoData!.valuePark)/3 ;
    if (mosMean <= 25) {
      url = "${mosImgList[0]}";
    }
    else if(25 < mosMean && mosMean <= 75) {
      url = "${mosImgList[1]}";
    }
    else {
      url = "${mosImgList[2]}";
    }
  }

// 이미지 URL과 색상을 선택하는 함수
  void selectImgAndColor(double mosquitoValue, String mosquitoType) {
    int index;
    if (mosquitoValue <= 25) {
      index = 0;
    } else if (mosquitoValue <= 75) {
      index = 1;
    } else {
      index = 2;
    }
    // 모기 위치변 선택
    switch(mosquitoType) {
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
      body: isLoading ? const Center(child: CircularProgressIndicator()):
      // [수정] UI Overflow 오류를 해결하기 위해 SingleChildScrollView로 감쌉니다.
      SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 20),
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
                  padding: const EdgeInsets.only(right: 20, top: 25),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => user_Page()),
                        );
                      }, child: ClipOval(
                      child: Image.asset("images/playstore.png",
                          width: 40,
                          height: 40
                      )
                  )
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 5,
                    child: Container(
                        width: 360,
                        // [수정] UI Overflow를 방지하기 위해 Card의 고정 높이를 제거합니다.
                        // height: 650,
                        child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text("오늘의 모기 지수",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 50),
                                              child: Text(
                                                  mosquitoData!.date
                                              )
                                          )
                                        ]
                                    ),
                                  ),
                                  Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Text(((mosquitoData!.valueWater + mosquitoData!.valueHouse + mosquitoData!.valuePark)/3).toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: Color(int.parse(selectedColorMean)),
                                                  fontSize: 64,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(),
                                            child: Image.asset(
                                              url,
                                              width: 120,
                                              height: 120,
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text("주거지",
                                            style: TextStyle(
                                                letterSpacing: 2.0,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20, left: 50),
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(selectedColorHouse)),
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                      Text(mosquitoData!.valueHouse.toString(), style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      Padding(padding: const EdgeInsets.only(left: 50),
                                          child: Image.asset(selectedImgUrlHouse,
                                            width: 80,
                                            height: 80,
                                          )
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text("공원",
                                            style: TextStyle(
                                                letterSpacing: 2.0,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20, left: 65),
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(selectedColorPark)),
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                      Text(mosquitoData!.valuePark.toString(), style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      Padding(padding: const EdgeInsets.only(left: 50),
                                          child: Image.asset(selectedImgUrlPark,
                                            width: 80,
                                            height: 80,
                                          )
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text("수변지",
                                        style: TextStyle(
                                            letterSpacing: 2.0,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20, left: 50),
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(selectedColorWater)),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  Text(mosquitoData!.valueWater.toString(),
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: Image.asset(selectedImgUrlWater,
                                        width: 80,
                                        height: 80,
                                      )
                                  )
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 20, bottom: 20), // [수정] 하단에도 패딩 추가
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Row(children: [
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                color: const Color(0xfffF97777),
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            const Text("모기위험")
                                          ],
                                          ),
                                          const Text("76 ~ 100")
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(children: [
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                color: const Color(0xfffFFC178),
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            const Text("모기주의")
                                          ],
                                          ),
                                          const Text("26 ~ 75")
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(children: [
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                color: const Color(0xfff95DB94),
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            const Text("모기안전")
                                          ],
                                          ),
                                          const Text("0 ~ 25")
                                        ],
                                      ),
                                    ],
                                  )
                              )
                            ]
                        )
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}