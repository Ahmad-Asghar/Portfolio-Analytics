import 'package:animated_flip_counter/animated_flip_counter.dart';
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
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.isLoading
                        ? 1
                        : provider.visitors.length + (provider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (provider.isLoading) {
                        return const Center(child: CustomLoadingIndicator());
                      }

                      if (provider.errorMessage != null) {
                        return Center(
                          child: CustomTextWidget(
                            title: provider.errorMessage!,
                            color: AppColors.white,
                          ),
                        );
                      }

                      if (provider.visitors.isEmpty) {
                        return Center(
                          child: CustomTextWidget(
                            title: "No visitors found",
                            color: AppColors.white,
                          ),
                        );
                      }

                      if (index == provider.visitors.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CustomLoadingIndicator(color: AppColors.primaryColor),
                          ),
                        );
                      }

                      final visitor = provider.visitors[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: CustomTextWidget(
                            title: '${index + 1}',
                            color: AppColors.white,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              constraints:BoxConstraints(
                                maxWidth: 35.w
                              ),
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
