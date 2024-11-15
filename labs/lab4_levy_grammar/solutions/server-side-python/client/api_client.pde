import http.requests.*;

class API_Client{
  
  GetRequest req;
  
  //PostRequest post;
  String get_msg_api="";
  // ---- CONSTRUCTOR ----
  API_Client(String mainUrl){
    // your code here ...
    this.get_msg_api=mainUrl+"/get_msgs";
    this.req = new GetRequest(this.get_msg_api); 
    
  }
  
  // ---- METHODS ----
  String[] get_msgs(){
    // your code here ...
    this.req.send();
    
    if (VERBOSE){
      println("Response Content: " + req.getContent());
    }
    JSONObject JSONobj = parseJSONObject(req.getContent());
    JSONArray JSONmsgs = JSONobj.getJSONArray("msgs"); 
    String[] msgs=new String[JSONmsgs.size()]; 
    for (int t=0; t<JSONmsgs.size(); t++){      
      msgs[t] = JSONmsgs.getString(t);    
    } 
    return msgs;
  }
}
