class UserModel {
  User? user;

  UserModel({this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? empId;
  List<Leaves>? leaves;
  List<LeaveBalanceDetail>? leaveBalanceDetail;
  List<QuickActions>? quickActions;
  List<ActivityTimeline>? activityTimeline;

  User(
      {this.name,
        this.empId,
        this.leaves,
        this.leaveBalanceDetail,
        this.quickActions,
        this.activityTimeline});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    empId = json['empId'];
    if (json['leaves'] != null) {
      leaves = <Leaves>[];
      json['leaves'].forEach((v) {
        leaves!.add(new Leaves.fromJson(v));
      });
    }
    if (json['leaveBalanceDetail'] != null) {
      leaveBalanceDetail = <LeaveBalanceDetail>[];
      json['leaveBalanceDetail'].forEach((v) {
        leaveBalanceDetail!.add(new LeaveBalanceDetail.fromJson(v));
      });
    }
    if (json['quickActions'] != null) {
      quickActions = <QuickActions>[];
      json['quickActions'].forEach((v) {
        quickActions!.add(new QuickActions.fromJson(v));
      });
    }
    if (json['activityTimeline'] != null) {
      activityTimeline = <ActivityTimeline>[];
      json['activityTimeline'].forEach((v) {
        activityTimeline!.add(new ActivityTimeline.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['empId'] = this.empId;
    if (this.leaves != null) {
      data['leaves'] = this.leaves!.map((v) => v.toJson()).toList();
    }
    if (this.leaveBalanceDetail != null) {
      data['leaveBalanceDetail'] =
          this.leaveBalanceDetail!.map((v) => v.toJson()).toList();
    }
    if (this.quickActions != null) {
      data['quickActions'] = this.quickActions!.map((v) => v.toJson()).toList();
    }
    if (this.activityTimeline != null) {
      data['activityTimeline'] =
          this.activityTimeline!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  String? name;
  int? count;
  String? description;

  Leaves({this.name, this.count, this.description});

  Leaves.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    data['description'] = this.description;
    return data;
  }
}

class LeaveBalanceDetail {
  String? name;
  int? count;
  int? total;

  LeaveBalanceDetail({this.name, this.count, this.total});

  LeaveBalanceDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    data['total'] = this.total;
    return data;
  }
}

class QuickActions {
  String? action;
  String? desc;
  bool? lock;

  QuickActions({this.action, this.desc, this.lock});

  QuickActions.fromJson(Map<String, dynamic> json) {
// Convert int or bool to bool
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value != 0;
      return false;
    }


    action = json['action'];
    desc = json['desc'];
    lock = parseBool(json['lock']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['desc'] = this.desc;
    data['lock'] = this.lock;
    return data;
  }
}

class ActivityTimeline {
  String? activity;
  String? desc;
  String? date;

  ActivityTimeline({this.activity, this.desc, this.date});

  ActivityTimeline.fromJson(Map<String, dynamic> json) {
    activity = json['activity'];
    desc = json['desc'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity'] = this.activity;
    data['desc'] = this.desc;
    data['date'] = this.date;
    return data;
  }
}
