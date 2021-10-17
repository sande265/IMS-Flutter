import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ims_flutter/api/api.dart';
import 'package:ims_flutter/theme/app_theme.dart';
import 'dart:math';

class SalesSummaryView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final List<dynamic>data;

  const SalesSummaryView(
      {Key? key, this.animationController, this.animation, required this.data})
      : super(key: key);

  @override
  _SalesSummaryViewState createState() => _SalesSummaryViewState();
}

class _SalesSummaryViewState extends State<SalesSummaryView> {
  // var data = [];
  // var loading = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 4, bottom: 8, top: 16),
                            child: Text(
                              'Sales Summary',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: AppTheme.darkText),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: const BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        DataTable(
                          dataRowHeight: 70.0,
                          columns: const [
                            DataColumn(label: Text('Product Name')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Price'))
                          ],
                          rows: widget.data.isNotEmpty
                              ? widget.data
                              .map((item) => DataRow(cells: [
                            DataCell(Text(substr(item['product_name']))),
                            DataCell(Text('${item['qty']}')),
                            DataCell(Text(
                                '${item['sale_price']}')),
                          ]))
                              .toList()
                              : [
                            const DataRow(cells: [
                              DataCell(Text('')),
                              DataCell(Text('No Data')),
                              DataCell(Text(''))
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  substr(String string) {
    var stripped = string.substring(0, min(string.length, 30));
    return stripped;
  }

  void _showToast(BuildContext context, message, color) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$message'),
        backgroundColor: color,
        action:
            SnackBarAction(label: 'X', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
