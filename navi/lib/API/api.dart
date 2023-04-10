import 'dart:convert';
import 'package:dio/src/form_data.dart';
import 'package:http/http.dart' as http;

// This class groups up several request types together such as post and get requests.
class CallApi {
  // the url address is the start point for varies other requests.
  // the local machine is the emulator since we are in that
  // currently but we are trying to access
  // to our laptop as the machine.
  final String url = 'http://10.143.11.150:5000/';

  // used to set the headers
  setHeaders() => {
        'Content-type':
            'application/json', // sends the data accompanied with the request in json format
        'Accept':
            'application/json', // expects the data returned by the server to be json as well
      };

  // post requests will be handled with this function.
  // the data to be passed as the body of the request is given as an argument to the function
  postData(data, apiUrl) async {
    var fullUrlString = url + apiUrl;
    Uri fullUrl = Uri.parse(fullUrlString); // convert the string to url
    return http.post(fullUrl, body: data, headers: setHeaders());
  }

  // get requests will be handled with this function
  getData(apiUrl) async {
    var fullUrlString = url + apiUrl;
    Uri fullUrl = Uri.parse(fullUrlString); // convert the string to url
    var response = await http.get(fullUrl);

    return response;
  }
}
