import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flag/flag.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_analytics/utils/app_exports.dart';
import 'package:my_portfolio_analytics/utils/user_pref_utils.dart';
import 'package:my_portfolio_analytics/views/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
import '../../common/models/visitor_model.dart';

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

          Map<String, List<VisitorModel>> groupVisitorsByDate(List<VisitorModel> visitors) {
            Map<String, List<VisitorModel>> groupedVisitors = {};
            final dateFormatter = DateFormat("d MMMM y");

            for (var visitor in visitors) {
              DateTime visitorDate = visitor.timestamp?.toDate() ?? DateTime(2000, 1, 1);
              String dateKey = dateFormatter.format(visitorDate);

              groupedVisitors.putIfAbsent(dateKey, () => []);
              groupedVisitors[dateKey]!.add(visitor);
            }

            return groupedVisitors;
          }
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
                        title: "Total Visitors",
                        fontFamily: AppConstants.secondFontFamily,
                        color: AppColors.white,
                        fontSize: 20.sp,
                      ),
                      AnimatedFlipCounter(
                        textStyle: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        duration: const Duration(milliseconds: 500),
                        value: provider.totalVisitors,
                      ),
                    ],
                  ),
                ),
                provider.isLoading
                    ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(child: CustomLoadingIndicator()
                    )
                ) : provider.visitors.isEmpty
                    ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: CustomTextWidget(
                        title: "No Visitors Found",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ) :
                Expanded(
                  child: FutureBuilder(
                    future: Future.value(groupVisitorsByDate(provider.visitors)),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CustomLoadingIndicator());
                      }

                      Map<String, List<VisitorModel>> groupedVisitors = snapshot.data!;
                      List<String> sectionTitles = groupedVisitors.keys.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: sectionTitles.length,
                        itemBuilder: (context, sectionIndex) {
                          String sectionTitle = sectionTitles[sectionIndex];
                          List<VisitorModel> sectionVisitors = groupedVisitors[sectionTitle]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                width: double.infinity,
                                color:AppColors.white,
                                child: Center(
                                  child: CustomTextWidget(
                                    fontFamily: AppConstants.secondFontFamily,
                                    title: sectionTitle,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...sectionVisitors.map((visitor) {
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: AppColors.greySettingsColor)
                                      )
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: CustomTextWidget(
                                        title: '${provider.visitors.indexOf(visitor) + 1}',
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
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          constraints:BoxConstraints(
                                            maxWidth:  50.w,
                                          ),
                                          child: CustomTextWidget(
                                            maxLines: 2,
                                            title: '${visitor.city ?? "--"}, ${visitor.region ?? "--"}, ${visitor.country ?? "--"}',
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        Flag.fromString(visitor.country??"null",height: 16,width: 40,)
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}