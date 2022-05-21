import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/components/CategoryHWidget.dart';
import 'package:money_manager/components/ExpenseTabBar.dart';
import 'package:money_manager/screens/ExchangeMoney.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'TitleText1.dart';

class BudgetTaskBar extends StatelessWidget {
  const BudgetTaskBar({Key? key, required this.isExpense}) : super(key: key);

  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 5, // length of tabs
      initialIndex: ApplicationState.getInstance.timeTab,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TabBar(
              labelColor: const Color.fromARGB(255, 35, 111, 87),
              labelStyle: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.black,
              indicatorWeight: 2.2.sp,
              indicatorColor: const Color.fromARGB(255, 35, 111, 87),
              padding: EdgeInsets.only(top: 10.h, left: 0.w, right: 10.w),
              indicatorPadding:
                  EdgeInsets.only(left: 25.0.w, bottom: 5.0.h, right: 1.w),
              labelPadding: EdgeInsets.only(left: 23.0.w),
              isScrollable: true,
              tabs: const [
                Tab(text: 'Ngày'),
                Tab(text: 'Tuần'),
                Tab(text: 'Tháng'),
                Tab(text: 'Năm'),
                Tab(text: 'Khoảng thời gian'),
              ],
            ),
            Container(
              height: 400.h, //height of TabBarView
              decoration: const BoxDecoration(),
              child: TabBarView(
                children: <Widget>[
                  TransactionsByCategoryWidget(
                      dateTimeRange: DateTimeRange(
                          start: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          end: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day)),
                      tab: TAB.DATE,
                      isExpense: isExpense),
                  // Center(
                  //   child: Column(
                  //     children: <Widget>[
                  //       DatePicker1(),
                  //       TitleText1(text: 'Tổng cộng: 2,000,000 đ', fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.bold, r: 0, g: 0, b: 0),
                  //       // Padding(
                  //       //   padding: EdgeInsets.only(left: 260.w, top: 280.h),
                  //       //   child: PlusButton(),
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  Center(
                      child: TitleText1(
                          text: 'Tab 2',
                          fontFamily: 'Inter',
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          r: 0,
                          g: 0,
                          b: 0)),
                  Center(
                      child: TitleText1(
                          text: 'Tab 3',
                          fontFamily: 'Inter',
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          r: 0,
                          g: 0,
                          b: 0)),
                  Center(
                      child: TitleText1(
                          text: 'Tab 4',
                          fontFamily: 'Inter',
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          r: 0,
                          g: 0,
                          b: 0)),
                  // Center(
                  //   child: Column(
                  //     children: <Widget>[
                  //       DateRangePicker(),
                  //       TitleText1(text: 'Tổng cộng: 2,000,000 đ', fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.bold, r: 0, g: 0, b: 0),
                  //       // Padding(
                  //       //   padding: EdgeInsets.only(left: 260.w, top: 280.h, bottom: 1.h),
                  //       //     child: PlusButton(),
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  TransactionsByCategoryWidget(
                      tab: TAB.RANGE, isExpense: isExpense),
                ],
              ),
            ),
          ]),
    );
  }
}

class TransactionsByCategoryWidget extends StatefulWidget {
  final bool isExpense;
  DateTimeRange? dateTimeRange;
  final TAB tab;

  TransactionsByCategoryWidget(
      {Key? key,
      this.dateTimeRange,
      required this.tab,
      required this.isExpense})
      : super(key: key);

  @override
  _TransactionsByCategoryState createState() {
    ApplicationState.getInstance.timeTab = tab.index;
    dateTimeRange ??= DateTimeRange(
        start: DateTime(DateTime.now().year, DateTime.now().month),
        end: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    return _TransactionsByCategoryState(
        dateTimeRange: dateTimeRange!, tab: tab, isExpense: isExpense);
  }
}

class _TransactionsByCategoryState extends State<TransactionsByCategoryWidget> {
  final bool isExpense;
  DateTimeRange dateTimeRange;
  final TAB tab;
  int _amount = 0;

  _TransactionsByCategoryState(
      {required this.dateTimeRange,
      required this.tab,
      required this.isExpense});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _setDateTimeRange(DateTimeRange dateTimeRange) {
    setState(() {
      this.dateTimeRange = dateTimeRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: ApplicationState.getInstance,
      builder: (context, _) =>
          Consumer<ApplicationState>(builder: (context, appState, _) {
        return Center(
          child: Column(
            children: <Widget>[
              dateTimeRangeWidget(tab),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('userData/${appState.user!.uid}/transactions')
                    .where('isExpense', isEqualTo: isExpense)
                    .where('date',
                        isGreaterThanOrEqualTo: DateTime(
                            dateTimeRange.start.year,
                            dateTimeRange.start.month,
                            dateTimeRange.start.day))
                    .where('date',
                        isLessThanOrEqualTo: DateTime(dateTimeRange.end.year,
                            dateTimeRange.end.month, dateTimeRange.end.day))
                    // .orderBy('date', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading');
                  }
                  int amount = 0;
                  for (final DocumentSnapshot doc in snapshot.data!.docs) {
                    amount += doc['value'] as int;
                  }
                  _amount = amount;
                  return TitleText1(
                      text: amount < 1000000
                          ? 'Tổng cộng: $_amount ₫'
                          : 'Tổng cộng: ${(_amount ~/ 100000) / 10} Tr ₫',
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      r: 0,
                      g: 0,
                      b: 0);
                },
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('userData/${appState.user!.uid}/transactions')
                    .where('isExpense', isEqualTo: isExpense)
                    .where('date',
                        isGreaterThanOrEqualTo: DateTime(
                            dateTimeRange.start.year,
                            dateTimeRange.start.month,
                            dateTimeRange.start.day))
                    .where('date',
                        isLessThanOrEqualTo: DateTime(dateTimeRange.end.year,
                            dateTimeRange.end.month, dateTimeRange.end.day))
                    // .orderBy('date', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading');
                  }
                  int sum = 0;
                  final Map<String, int> categories = {};
                  for (final DocumentSnapshot document in snapshot.data!.docs) {
                    categories.update(document['categoryID'],
                        (value) => value + document['value'] as int,
                        ifAbsent: () => document['value'] as int);
                    sum += document['value'] as int;
                  }
                  final Map<String, int> sortedCategories = SplayTreeMap.from(
                      categories,
                      (key1, key2) =>
                          categories[key2]!.compareTo(categories[key1]!));
                  return ListView.builder(
                    itemCount: sortedCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String key = sortedCategories.keys.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExchangeMoney(
                                        typeIndex: isExpense ? 0 : 1,
                                        timeIndex: tab.index,
                                        categoryID: key,
                                      )));
                        },
                        child: AmountForCategoryWidget(
                            categoryID: key,
                            amount: sortedCategories[key]!,
                            percentage:
                                (sortedCategories[key]! * 100.0 / sum).round()),
                      );
                    },
                  );
                },
              ))
            ],
          ),
        );
      }),
    );
  }

  Widget dateTimeRangeWidget(TAB tab) {
    final DateTime start = DateTime(dateTimeRange.start.year,
        dateTimeRange.start.month, dateTimeRange.start.day);
    final DateTime end = DateTime(
        dateTimeRange.end.year, dateTimeRange.end.month, dateTimeRange.end.day);
    final DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    switch (tab) {
      case TAB.DATE:
        Future<Function?> onPress() async {
          final newDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            builder: (context, child) => Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                    primary: Color.fromARGB(255, 35, 111, 87)),
              ),
              child: child as Widget,
            ),
          );
          if (newDate != null) {
            _setDateTimeRange(DateTimeRange(start: newDate, end: newDate));
          }
          return null;
        }
        if (start.year == now.year) {
          if (start.isAtSameMomentAs(now)) {
            return TextButton(
                onPressed: onPress,
                child: Text('Hôm nay, ${start.day} tháng ${start.month}',
                    style: const TextStyle(color: Colors.black)));
          } else if (start
              .isAtSameMomentAs(now.subtract(const Duration(days: 1)))) {
            return TextButton(
                onPressed: onPress,
                child: Text('Hôm qua, ${start.day} tháng ${start.month}',
                    style: const TextStyle(color: Colors.black)));
          } else {
            return TextButton(
                onPressed: onPress,
                child: Text('${start.day} tháng ${start.month}',
                    style: const TextStyle(color: Colors.black)));
          }
        } else {
          return TextButton(
              onPressed: onPress,
              child: Text('${start.day} tháng ${start.month}, ${start.year}',
                  style: const TextStyle(color: Colors.black)));
        }
      // case TAB.WEEK:
      //   Future<Function?> onPress() async {
      //     final newDate = await showDateRangePicker(
      //       context: context,
      //       initialDateRange: ,
      //       firstDate: DateTime(DateTime.now().year - 1),
      //       lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      //       builder: (context, child) => Theme(
      //         data: ThemeData.light().copyWith(
      //           colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 35, 111, 87)),
      //         ),
      //         child: child as Widget,
      //       ),
      //     );
      //     if (newDate!= null){
      //       _setDateTimeRange(DateTimeRange(start: newDate, end: newDate));
      //     }
      //   }
      //   if (start.year == now.year){
      //     if (start.isAtSameMomentAs(now)){
      //       return TextButton(onPressed: onPress, child: Text('Hôm nay, ${start.day} tháng ${start.month}'));
      //     } else if (start.isAtSameMomentAs(now.subtract(const Duration(days: 1)))){
      //       return TextButton(onPressed: onPress, child: Text('Hôm qua, ${start.day} tháng ${start.month}'));
      //     } else {
      //       return TextButton(onPressed: onPress, child: Text('${start.day} tháng ${start.month}'));
      //     }
      //   } else {
      //     return TextButton(onPressed: onPress, child: Text('${start.day} tháng ${start.month}, ${start.year}'));
      //   }
      case TAB.RANGE:
        if (start.year == end.year) {
          return TextButton(
              onPressed: selectRange,
              child: Text(
                  'Từ ${start.day}/${start.month} đến ${end.day}/${end.month}/${end.year}',
                  style: const TextStyle(color: Colors.black)));
        } else {
          return TextButton(
              onPressed: selectRange,
              child: Text(
                  'Từ ${start.day}/${start.month}/${start.year} đến ${end.day}/${end.month}/${end.year}',
                  style: const TextStyle(color: Colors.black)));
        }
      default:
        return const Text('ADU');
    }
  }

  Future<Function?> selectRange() async {
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 20),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      initialDateRange: DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month),
          end: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 35, 111, 87)),
        ),
        child: child as Widget,
      ),
    );
    if (newDateRange != null) {
      _setDateTimeRange(
          DateTimeRange(start: newDateRange.start, end: newDateRange.end));
    }
    return null;
  }
}

class AmountForCategoryWidget extends StatelessWidget {
  const AmountForCategoryWidget(
      {Key? key,
      required this.categoryID,
      required this.amount,
      this.onPress,
      required this.percentage})
      : super(key: key);

  final String categoryID;
  final int amount;
  final int percentage;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onPress,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 23.w, top: 30.h),
            child: ApplicationState.getInstance.getCategory(categoryID) != null
                ? CategoryHWidget(
                    category:
                        ApplicationState.getInstance.getCategory(categoryID)!,
                  )
                : const Text('Lỗi: Không tìm thấy danh mục'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 1.w, top: 30.h),
            child: Container(
              width: 40,
              child: Text(
                '$percentage%',
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, top: 30.h, right: 17.w),
            child: Container(
              width: 100,
              child: Text(
                amount < 1000000
                    ? '$amount ₫'
                    : '${(amount ~/ 100000) / 10} Tr ₫',
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
