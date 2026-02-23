import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  scenarios: {
    users_me_load: {
      executor: "constant-vus",
      vus: Number(__ENV.VUS || 5),
      duration: __ENV.DURATION || "1m",
    },
  },
  thresholds: {
    http_req_failed: ["rate<0.1"],
    http_req_duration: ["p(95)<1000"],
  },
};

const BASE_URL = __ENV.BASE_URL || "http://api.checkmate";
const TOKEN = __ENV.TOKEN || "";

export default function () {
  const headers = TOKEN ? { Authorization: `Bearer ${TOKEN}` } : {};

  const res = http.get(`${BASE_URL}/users/me`, { headers, tags: { endpoint: "users_me" } });

  check(res, {
    "status is 200 or 401": (r) => r.status === 200 || r.status === 401,
  });

  sleep(Number(__ENV.SLEEP || 0.5));
}
