import 'package:flutter/material.dart';
import 'package:ims_flutter/Screens/views/sales_summary_view.dart';
import 'package:ims_flutter/Screens/views/glass_view.dart';
import 'package:ims_flutter/Screens/views/meals_list_view.dart';
import 'package:ims_flutter/Screens/views/daily_sales_view.dart';
import 'package:ims_flutter/Screens/views/title_view.dart';
import 'package:ims_flutter/Screens/views/water_view.dart';
import 'package:ims_flutter/api/api.dart';
import 'package:ims_flutter/theme/app_theme.dart';
import 'package:ims_flutter/widgets/refresh_widget.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  late var data = [];

  var currentDate = DateTime.now().toString().split(" ")[0];

  Map<String, dynamic> datas = {
    "total_amount": '',
    "total_qty": '',
    "monthly_total": '',
  };

  var loading = true;

  late Future<bool> dataFuture;

  @override
  void initState() {
    dataFuture = getData();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    // addAllListData();
    // getData();
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    getDateToday();
    var response = await Api().getData('/sales?date=$currentDate');
    if (response == null) {
      _showToast(context, 'No Internet Connection', Colors.red);
      if (listViews.isNotEmpty) {
        listViews = [];
      }
      listViews.add(
        TitleView(
          titleTxt: 'No Internet',
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController!,
              curve: const Interval((1 / 9) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!,
        ),
      );
      return true;
    }
    if (response['message'] != null && response['data'] == null) {
      _showToast(context, response['message'], Colors.red);
      setState(() {
        data = [];
        datas = {
          "monthly_total": response['monthly_total'],
        };
      });
      print('error');
      addAllListData([]);
      return true;
    } else {
      setState(() {
        data = response['data'] ?? [];
        datas = {
          "total_amount": response['total_amount'],
          "total_qty": response['total_qty'],
          "monthly_total": response['monthly_total'],
        };
      });
      addAllListData(response['data'] ?? []);
      return true;
    }
  }

  void addAllListData(_data) {
    const int count = 9;
    if (listViews.isNotEmpty) {
      listViews = [];
    }
    listViews.add(
      TitleView(
        titleTxt: 'Daily Stats',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            const Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      DailySalesView(
        data: datas,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            const Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Summary',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            const Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      SalesSummaryView(
        data: _data,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            const Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      GlassView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController!,
                  curve: const Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshWidget(
        onRefresh: getData,
        child: Container(
          color: AppTheme.background,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                getMainListViewUI(),
                getAppBarUI(),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: dataFuture,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'IMS',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {
                                  changeDate("-");
                                },
                                child: const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: AppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    getDateToday(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: AppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {
                                  changeDate("+");
                                },
                                child: const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  void _showToast(BuildContext context, message, color) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$message'),
        backgroundColor: color,
        action:
        SnackBarAction(
            label: 'X',
            onPressed: scaffold.hideCurrentSnackBar,
          textColor: Colors.white,
        ),
      ),
    );
  }

  getDateToday() {
    var date = DateFormat.yMMMMd('en_US').format(DateTime.parse(currentDate));
    String strippedDate;
    String m = date.split(' ')[0].substring(0, 3);
    String d = date.split(" ")[1].split(',')[0];
    strippedDate = m +' '+ d;
    return strippedDate;
  }

  changeDate(String type) {
    var a = currentDate.substring(0, 7);
    var b = currentDate.split("-")[2];
    if (type == '+') {
      int day = int.parse(b);
      day++;
      setState(() {
        currentDate = a + '-' + day.toString();
      });
    } else {
      int day = int.parse(b);
      day--;
      setState(() {
        currentDate = a + '-' + day.toString();
      });
    }
    getData();
  }
}
