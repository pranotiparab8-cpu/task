
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:stacked/stacked.dart';

import '../../../util/helper.dart';
import 'dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(
      BuildContext context,
      DashboardViewModel model,
      Widget? child) {
    print("istablet ${ScreenSize.isTablet(context)}");
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: ScreenSize.isMobile(context)
      ? AppBar(
        title: const Text("Dashboard"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ) : null,
      drawer: ScreenSize.isMobile(context)
          ? Drawer(child: buildSidebar(model))
          : null,
      body: Row(
        children: [
          if (!ScreenSize.isMobile(context))
          buildSidebar(model),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Builder(
                    builder: (_) {
                      switch (model.selectedMenu) {
                        case "Dashboard":
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Welcome, ${model.userModel?.user?.name ?? ''}",
                                  style:
                                  TextStyle(fontSize: ScreenSize.getFontSize(
                                    context,
                                    mobile: 18,
                                    tablet: 22,
                                    desktop: 26,
                                  ), fontWeight: FontWeight.bold)),

                              SizedBox(height: 20),
                              Text(
                                "Here's an overview of your leaves, expenses, and upcoming holidays",
                                style: TextStyle(
                                  fontSize: ScreenSize.getFontSize(
                                    context,
                                    mobile: 12,
                                    tablet: 16,
                                    desktop: 20,
                                  ),
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 20),

                              stats(model, context),

                              SizedBox(height: 20),

                              ScreenSize.isMobile(context) || ScreenSize.isTablet(context)
                                  ? Column(
                                children: [
                                  // Expanded(
                                  //   child: AspectRatio(
                                  //     aspectRatio: 4,
                                  //     child: _buildUpcoming(),
                                  //   ),
                                  // ),
                                  SizedBox(
                                      height: 200,
                                      child: _buildUpcoming()),
                                  const SizedBox(height: 20),
                                  // Expanded(
                                  //   child: AspectRatio(
                                  //     aspectRatio: 4,
                                  //     child: _buildLeaveDetails(model, context),
                                  //   ),
                                  // ),
                                  SizedBox(
                                      height: 212,
                                      child: _buildLeaveDetails(model, context)),
                                ],
                              ):
                              Row(
                                children: [
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 3,
                                      child: _buildUpcoming(),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 3,
                                      child: _buildLeaveDetails(model, context),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),

                              ScreenSize.isMobile(context) || ScreenSize.isTablet(context)
                                  ? Column(
                                children: [
                                  SizedBox(
                                      child: _buildQuickActions(model, context)),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                      child: _buildTimeline(model, context)),
                                ],
                              ):
                              Row(
                                children: [
                                  Expanded(
                                    child: AspectRatio(
                                        aspectRatio: 1.5,
                                        child: _buildQuickActions(model, context)
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: AspectRatio(
                                        aspectRatio: 1.5,
                                        child: _buildTimeline(model, context)
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        case "Holidays":
                          return Center(child: Text("Holidays Page Coming Soon"));

                        case "Leave Management":
                          return Center(child: Text("Leave Management Page Coming Soon"));

                        case "Expense Management":
                          return Center(child: Text("Expense Management Page Coming Soon"));

                        default:
                          return Center(child: Text("Select a Menu"));
                      }

                    })
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSidebar(DashboardViewModel model) {
    return Container(
      width: 250,
      color: Color(0xff4532DC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          ListTile(
            leading: const Icon(Icons.group_rounded, color: Colors.white),
            title: const Text(
              "User Panel",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              model.isUserPanelExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            onTap: model.toggleUserPanel,
          ),

          if (model.isUserPanelExpanded)
            Column(
              children: [
                submenuItem("Dashboard", Icons.home, model),
                submenuItem("Holidays", Icons.calendar_month, model),
                submenuItem("Leave Management", Icons.event_note, model),
                submenuItem("Expense Management", Icons.receipt_long, model),
              ],
            ),
          menuItem("Manager Panel"),
          menuItem("Admin Panel"),
        ],
      ),
    );
  }

  Widget menuItem(String title) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
    );
  }

  Widget submenuItem(String title, IconData icon, DashboardViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70, size: 20),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        onTap: () {
          model.selectMenu(title);
        },
      ),
    );
  }

  Widget stats(DashboardViewModel model, BuildContext context) {
    final leave = model.userModel?.user?.leaves;
    if (leave == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return
      ScreenSize.isMobile(context) || ScreenSize.isTablet(context) ?
      Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: card(
                    leave[0].name ?? "",
                    leave[0].count ?? 0,
                    leave[0].description ?? "",
                    context,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: card(
                    leave[1].name ?? "",
                    leave[1].count ?? 0,
                    leave[1].description ?? "",
                    context,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                card(leave[2].name ?? "", leave[2].count ?? 0, leave[2].description ?? "", context),
                card(leave[3].name ?? "", leave[3].count ?? 0, leave[3].description ?? "", context),
              ],
            ),
          ),
        ],
      ):
      Row(
      children: [
        card(leave[0].name ?? "", leave[0].count ?? 0, leave[0].description ?? "", context),
        card(leave[1].name ?? "", leave[1].count ?? 0, leave[1].description ?? "", context),
        card(leave[2].name ?? "", leave[2].count ?? 0, leave[2].description ?? "", context),
        card(leave[3].name ?? "", leave[3].count ?? 0, leave[3].description ?? "", context),
      ],
    );
  }

  Widget card(String title, int value, String desc, BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenSize.getFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),),
              ),
              SizedBox(height: 10),
              Text("$value",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenSize.getFontSize(
                  context,
                  mobile: 22,
                  tablet: 24,
                  desktop: 24,
                ),),),
                  //TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("$desc",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: ScreenSize.getFontSize(
                  context,
                  mobile: 10,
                  tablet: 16,
                  desktop: 18,
                ),),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcoming() {
    return Card(
      color: Colors.white,
        child: Center(child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Upcoming Holidays", style: TextStyle(fontWeight: FontWeight.bold)),
        ))));
  }

  Widget _buildLeaveDetails(DashboardViewModel model, BuildContext context) {
    final leaveBalanceDetail = model.userModel?.user?.leaveBalanceDetail;
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Leave Balance Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenSize.getFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: ScreenSize.isMobile(context) || ScreenSize.isTablet(context) ? 3 : 4.5,
            ),
            itemCount: leaveBalanceDetail?.length ?? 0,
            itemBuilder: (context, index) {
              var leave = leaveBalanceDetail?[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leave?.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenSize.getFontSize(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                    ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${leave?.count ?? 0}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenSize.getFontSize(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 18,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ' / ${leave?.total ?? 0}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenSize.getFontSize(
                                context,
                                mobile: 10,
                                tablet: 10,
                                desktop: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(DashboardViewModel model, BuildContext context) {
    final quickActions = model.userModel?.user?.quickActions;
    return Card(
        color: Colors.white,
        child: Center(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenSize.getFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),),)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: ScreenSize.isMobile(context) || ScreenSize.isTablet(context) ? 3 : 3.5,
          ),
          itemCount: quickActions?.length ?? 0,
          itemBuilder: (context, index) {
            var action = quickActions?[index];
            return Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                action?.lock == true ? Icon(Icons.lock) : Container(width: 20),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action?.action ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenSize.getFontSize(
                          context,
                          mobile: 10,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                    Text(action?.desc ?? "",
                      style: TextStyle(
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenSize.getFontSize(
                          context,
                          mobile: 10,
                          tablet: 12,
                          desktop: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ],
    )));
  }

  Widget _buildTimeline(DashboardViewModel model, BuildContext context) {
    final activityTimeline = model.userModel?.user?.activityTimeline;
    return Card(
      color: Colors.white,
        child: Center(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("Activity Timeline", style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: ScreenSize.getFontSize(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 18,
                ),
              ),)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: activityTimeline?.length ?? 0,
          itemBuilder: (context, index) {
            var activity = activityTimeline?[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity?.activity ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenSize.getFontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 14,
                        ),
                      ),
                    ),
                    Text(activity?.desc ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenSize.getFontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 14,
                        ),
                      ),
                    ),
                    Text(activity?.date ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenSize.getFontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 14,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },)
      ],
    )));
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) {
    return DashboardViewModel();
  }

  @override
  void onViewModelReady(DashboardViewModel viewModel) {
    viewModel.init();
  }
}