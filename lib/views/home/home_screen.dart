import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_analytics/utils/app_exports.dart';
import 'package:my_portfolio_analytics/utils/user_pref_utils.dart';
import 'package:my_portfolio_analytics/views/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.fetchVisitors();
      provider.fetchTotalCount();
    });
  }

  void _onScroll() {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        provider.hasMore &&
        !provider.isFetchingMore) {
      provider.fetchMoreVisitors();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Image.asset(Images.logo),
        ),
        title: CustomTextWidget(
          title: "${getGreeting()} Ahmad,",
          color: AppColors.white,
          fontSize: 19.sp,
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          List<dynamic> sortedVisitors = List.from(provider.visitors)
            ..sort((a, b) => b.timestamp.toDate().compareTo(a.timestamp.toDate()));
          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchVisitors(isRefreshing: true);
              await provider.fetchTotalCount();
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        title: "Total Visitors Count",
                        color: AppColors.white,
                        fontSize: 19.sp,
                      ),
                      AnimatedFlipCounter(
                        textStyle: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: AppConstants.secondFontFamily,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        duration: const Duration(milliseconds: 500),
                        value: provider.totalVisitors,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GroupedListView<dynamic, DateTime>(
                    physics: const AlwaysScrollableScrollPhysics(),
                    elements: sortedVisitors,
                    groupBy: (visitor) {
                      DateTime dateTime = visitor.timestamp.toDate();
                      return DateTime(dateTime.year, dateTime.month, dateTime.day);
                    },
                    groupSeparatorBuilder: (DateTime date) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: CustomTextWidget(
                        title: DateFormat('dd MMMM yyyy').format(date),
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    itemBuilder: (context, visitor) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: CustomTextWidget(
                            title: '${sortedVisitors.indexOf(visitor) + 1}',
                            color: AppColors.white,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 35.w),
                              child: CustomTextWidget(
                                fontFamily: AppConstants.secondFontFamily,
                                maxLines: 1,
                                title: visitor.ip ?? "--- --- -- --",
                                color: AppColors.white,
                                fontSize: 15,
                              ),
                            ),
                            CustomTextWidget(
                              title: formatTimestamp(visitor.timestamp),
                              color: AppColors.white,
                              fontFamily: AppConstants.secondFontFamily,
                              fontSize: 13,
                            ),
                          ],
                        ),
                        subtitle: CustomTextWidget(
                          title:
                          '${visitor.city ?? "--"}, ${visitor.region ?? "--"}, ${visitor.country ?? "--"}',
                          color: AppColors.primaryColor,
                        ),
                      );
                    },
                    itemComparator: (item1, item2) =>
                        item2.timestamp.toDate().compareTo(item1.timestamp.toDate()),
                    order: GroupedListOrder.DESC,
                    separator: const Divider(height: 0),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
