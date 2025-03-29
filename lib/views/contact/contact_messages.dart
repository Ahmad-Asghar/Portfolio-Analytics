import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flag/flag.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_analytics/utils/app_exports.dart';
import 'package:my_portfolio_analytics/utils/user_pref_utils.dart';
import 'package:my_portfolio_analytics/views/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
import '../../common/models/contact_messages_model.dart';
import '../../common/models/visitor_model.dart';

class ContactMessagesScreen extends StatefulWidget {
  @override
  _ContactMessagesScreenState createState() => _ContactMessagesScreenState();
}

class _ContactMessagesScreenState extends State<ContactMessagesScreen> {
  late ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && provider.hasMoreMessages && !provider.isFetchingMoreMessages) {
      provider.fetchMoreMessages();
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
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        // leading: Padding(
        //   padding: const EdgeInsets.all(9.0),
        //   child: Image.asset(Images.logo),
        // ),
        centerTitle: true,
        title: CustomTextWidget(
          title: "Messages",
          color: AppColors.white,
          fontSize: 19.sp,
        ),
        // actions: [
        //   Consumer<HomeProvider>(
        //       builder: (context, provider, child) {
        //         return Stack(
        //           alignment: Alignment.topRight,
        //           children: [
        //             IconButton(onPressed: (){}, icon: Icon(Icons.message_rounded,color: AppColors.white,)),
        //             Container(
        //                 padding: const EdgeInsets.symmetric(horizontal: 3.0),
        //                 margin: const EdgeInsets.symmetric(horizontal: 6.0),
        //                 decoration:BoxDecoration(
        //                     borderRadius: BorderRadius.circular(5),
        //                     color: AppColors.primaryColor
        //                 ),
        //                 child: CustomTextWidget(title: provider.totalMessages.toString(),color: AppColors.white,))
        //           ],
        //         );
        //       }
        //   )
        // ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {

          Map<String, List<ContactMessagesModel>> groupVisitorsByDate(List<ContactMessagesModel> visitors) {
            Map<String, List<ContactMessagesModel>> groupedVisitors = {};
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
              await provider.fetchMessages(isRefreshing: true);
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
                        title: "Total Messages",
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
                        value: provider.totalMessages,
                      ),
                    ],
                  ),
                ),
                provider.isLoading
                    ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(child: CustomLoadingIndicator()
                    )
                ) : provider.contactMessages.isEmpty
                    ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: CustomTextWidget(
                        title: "No Messages Found",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ) :
                Expanded(
                  child: FutureBuilder(
                    future: Future.value(groupVisitorsByDate(provider.contactMessages)),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CustomLoadingIndicator());
                      }

                      Map<String, List<ContactMessagesModel>> groupedVisitors = snapshot.data!;
                      List<String> sectionTitles = groupedVisitors.keys.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: sectionTitles.length,
                        itemBuilder: (context, sectionIndex) {
                          String sectionTitle = sectionTitles[sectionIndex];
                          List<ContactMessagesModel> sectionVisitors = groupedVisitors[sectionTitle]!;

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
                                  child: Slidable(
                                    endActionPane:  ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          flex: 1,
                                          onPressed: (callBack){
                                            provider.deleteContactMessage(visitor.visitorId);
                                          },
                                          backgroundColor: AppColors.backgroundColor,
                                          foregroundColor: AppColors.githubColor,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: CustomTextWidget(
                                          title: '${provider.contactMessages.indexOf(visitor) + 1}',
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
                                              title: visitor.name.toString(),
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
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                constraints:BoxConstraints(
                                                  maxWidth:  50.w,
                                                ),
                                                child: CustomTextWidget(
                                                  maxLines: 2,
                                                  title: visitor.email.toString(),
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(text: visitor.email.toString()));
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text("Email copied to clipboard\n${visitor.email.toString()}"),
                                                      duration: const Duration(seconds: 2),
                                                      behavior: SnackBarBehavior.floating,
                                                    ),
                                                  );
                                                },
                                                child: Icon(Icons.copy, color: AppColors.white, size: 17),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          CustomTextWidget(title: visitor.message.toString(),color: AppColors.white,textAlign: TextAlign.start)
                                        ],
                                      ),
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