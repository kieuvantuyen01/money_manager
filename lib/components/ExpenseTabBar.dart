import 'package:flutter/material.dart';
import 'DatePicker.dart';
import 'DateRangePicker.dart';
import 'TitleText1.dart';

class ExpenseTabBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 5, // length of tabs
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        Container(
          child: TabBar(
            labelColor: Color.fromARGB(255, 35, 111, 87),
            labelStyle: TextStyle(fontSize: 15, fontFamily: 'Inter', fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black,
            indicatorWeight: 2.2,
            indicatorColor: Color.fromARGB(255, 35, 111, 87),
            padding: EdgeInsets.only(top: 10),
            indicatorPadding: EdgeInsets.only(left: 25.0, bottom: 5.0, right: 0.0),
            labelPadding: EdgeInsets.only(left: 25),
            isScrollable: true,
            tabs: [
              Tab(text: 'Ngày'),
              Tab(text: 'Tuần'),
              Tab(text: 'Tháng'),
              Tab(text: 'Năm'),
              Tab(text: 'Khoảng thời gian'),
            ],
          ),
        ),
        Container(
          height: 400, //height of TabBarView
          decoration: BoxDecoration(
          ),
          child: TabBarView(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      DatePicker(),
                    ],
                  ),
                ),
                Center(child: TitleText1(text: 'Tab 2', fontFamily: 'Inter', fontSize: 25, fontWeight: FontWeight.normal, r: 0, g: 0, b: 0)),
                Center(child: TitleText1(text: 'Tab 3', fontFamily: 'Inter', fontSize: 25, fontWeight: FontWeight.normal, r: 0, g: 0, b: 0)),
                Center(child: TitleText1(text: 'Tab 4', fontFamily: 'Inter', fontSize: 25, fontWeight: FontWeight.normal, r: 0, g: 0, b: 0)),
                Center(
                  child: Column(
                    children: <Widget>[
                      DateRangePicker(),
                    ],
                  ),
                ),
              ]
          ),
        ),
      ]),
    );
  }
}