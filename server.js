// Generated by CoffeeScript 1.7.1
(function() {
  var ERROR, PORT_NUMBER, http, manager, onAccess, returnError, server, url, writeJSON;

  PORT_NUMBER = 60064;

  http = require("http");

  url = require("url");

  manager = require("./streamManager.js");

  ERROR = {
    "not_get": "get only",
    "no_param": "no param",
    "no_id": "please set id",
    "invalid_method": "invalid method",
    "no_artist_name": "please enter artist name"
  };

  onAccess = function(req, res) {
    var p;
    console.log("################# onAccess #################");
    console.log(req.url);
    if (req.method !== "GET") {
      return returnError(res, ERROR['not_get']);
    } else {
      p = url.parse(req.url, true).query;
      if (!p) {
        return returnError(res, ERROR['no_param']);
      } else {
        console.log(p);
        switch (p.method) {
          case "start":
            if (!p.artist_name) {
              return returnError(res, ERROR['no_artist_name']);
            } else {
              return writeJSON(res, manager.startNewStream(p.artist_name, p.artist_id, p.mode));
            }
            break;
          case "get":
            if (!p.id) {
              return returnError(res, ERROR['no_id']);
            } else {
              return writeJSON(res, manager.getTracks(p.id, p.limit));
            }
            break;
          case "stop":
            if (!p.id) {
              return returnError(res, ERROR['no_id']);
            } else {
              return writeJSON(res, manager.stopStream(p.id));
            }
            break;
          default:
            return returnError(res, ERROR['invalid_method']);
        }
      }
    }
  };

  server = http.createServer(onAccess).listen(PORT_NUMBER);

  console.log("server started");

  writeJSON = function(res, obj) {
    res.writeHead(200, {
      "Content-Type": "application/json"
    });
    res.end(JSON.stringify(obj));
    console.log("WROTE: ");
    console.log(obj);
    return res;
  };

  returnError = function(res, message) {
    return writeJSON(res, {
      error_message: message
    });
  };

}).call(this);
