# client.js
function submit(){
  let data={“text":$("#textForm")[0].value};
  $.getJSON(URL+“send_msg", data=data, showRefresh);
}
