// "leaves": {
// "pending": {
// "name": "Pending Leaves",
// "count": 3,
// "description": "Awaiting approval from managers"
// },
// "approved": {
// "name": "Approved Leaves",
// "count": 12,
// "description": "Total leaves approved this month"
// },
// "expenses": {
// "name": "Expense Claims",
// "count": 5,
// "description": "Pending expense approvals"
// },
// "balance": {
// "name": "Leave Balance",
// "count": 33,
// "description": "Total available leave days"
// }
// },

// QuickActions.fromJson(Map<String, dynamic> json) {
// // Convert int or bool to bool
// bool parseBool(dynamic value) {
// if (value is bool) return value;
// if (value is int) return value != 0;
// return false;
// }
//
//
// action = json['action'];
// desc = json['desc'];
// lock = parseBool(json['lock']);
// }