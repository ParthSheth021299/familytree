enum AppRoutes {
  splashRoute(fullPath: "/", screenTitle: "Splash", relativePath: "splash"),
  adminDashboardRoute(
    fullPath: "/admin/dashboard",
    screenTitle: "AdminDashboard",
    relativePath: "admindashboard",
  ),
  createTempId(
    fullPath: "/admin/createTempId",
    screenTitle: "CreateTempID",
    relativePath: "createtempid",
  ),
  viewLogs(
    fullPath: "/admin/view-logs",
    screenTitle: "viewLogs",
    relativePath: "viewlogs",
  ),
  treeView(
    fullPath: "/treeview",
    screenTitle: "TreeView",
    relativePath: "treeview",
  ),
  members(
    fullPath: "/admin/members",
    screenTitle: "Members",
    relativePath: "memebers",
  ),
  createMemories(
    fullPath: "/admin/create-memeories",
    screenTitle: "createMemories",
    relativePath: "creatememories",
  ),
  memories(
    fullPath: "/memeories",
    screenTitle: "memories",
    relativePath: "memories",
  ),
  createEvent(
    fullPath: "/admin/create-event",
    screenTitle: "createEvent",
    relativePath: "createevent",
  ),
  events(fullPath: "/events", screenTitle: "events", relativePath: "events"),
  setting(
    fullPath: "/setting",
    screenTitle: "Setting",
    relativePath: "setting",
  ),
  language(
    fullPath: "/setting/language",
    screenTitle: "Language",
    relativePath: "language",
  ),
  login(fullPath: "/login", screenTitle: "Login", relativePath: "login"),
  guestDashboard(
    fullPath: "/guest/dashboard",
    screenTitle: "GuestDashboard",
    relativePath: "guestdashboard",
  );

  const AppRoutes({
    required this.fullPath,
    required this.screenTitle,
    this.relativePath = "",
  });
  final String fullPath;
  final String relativePath;
  final String screenTitle;

  static bool isValidRoute(String route) {
    return route.isNotEmpty;
  }
}
