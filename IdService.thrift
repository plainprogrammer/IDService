/* Copyright 2013 The Ready Project, LLC */

exception InvalidSystemClock {
  1: string message,
}

service IdService {
  i64 get_id()
}
