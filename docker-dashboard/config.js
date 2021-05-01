export const config = {
  URL: "https://www.stefanopropato.it",

  PORT_NUMBER: "443",
  SONAR_API:"sonarqube-api",

  API: {
    VERSION: "V1",
    LOGIN: "login",
    USER: "user",
    USERS: "users",
    LOGOUT: "logout",
    PROJECT: "project",
    ACTIVITY: "activity",
    REGISTER: "user",
    REPORTS: "Reports",
    ACTIVITIES_REPORT: "activitiesReport",
    TIME_REPORT: "timeReport",
    CUMUL_REPORT: "cumulativeReport",

    CONNECT_PROJECT: "ConnectProject",

    GITLAB_TOKEN: "api/v4/personal_access_tokens",
    GITLAB_PROJECTS: "api/v4/projects",

    TAIGA_TOKEN: "api/v1/auth",
    TAIGA_PROJECTS: "api/v1/projects",
    TAIGA_USERS: "api/v1/users",
    TAIGA_TASKS: "api/v1/tasks",
    TAIGA_U_STORIES: "api/v1/userstories",

    MATTERMOST_CHANNELS: "/api/v4/channels",
    MATTERMOST_USERS: "api/v4/users",

    SONAR_TOKEN: "api/user_tokens"

  },

  CONTENT_TYPES: {
    APPLICATION_JSON: "application/json",
    MULTIPART: "multipart/form-data",
  },

  REQ_TYPES: {
    GET: "GET",
    POST: "POST",
    PUT: "PUT",
    DELETE: "DELETE",
  },
};
