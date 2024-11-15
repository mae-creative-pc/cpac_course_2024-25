import http.requests.*;

class API_Client{
  
  GetRequest req;
  
  //PostRequest post;
  String get_msg_api="";
  // ---- CONSTRUCTOR ----
  API_Client(String mainUrl){
    // your code here ...
    // setup the request using the site api
    this.req = new GetRequest(mainUrl); //modify this
  ;    
  }
  
  // ---- METHODS ----
  String[] get_msgs(){
    // your code here ...
    // SEND THE REQUEST
    if(req.getContent()!= null)
    {
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
    else
    {
      String[] msgs=new String[1]; 
      msgs[0] = "";
      return msgs;
    }
}
}
