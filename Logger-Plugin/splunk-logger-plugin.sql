create or replace procedure log_splunk_plugin(
  p_rec in logger.rec_logger_log)
as
  l_text logger_logs.text%type;
  l_module varchar2(50);
  v_body CLOB;
  v_result CLOB;
   l_splunk_hec_token varchar2(64) := '772A30CD-6504-442C-9FE0-69FF7FF7F442';
   l_splunk_host varchar2(100)  := '192.168.56.1';
   l_splunk_port number         := 8081;
   l_splunk_ssl   boolean       := false;

   l_http_prefix varchar2(10)   := 'http';
   l_url         varchar2(255);
begin
  --dbms_output.put_line('In Plugin');
  --dbms_output.put_line('p_rec.id: ' || p_rec.id);

  select regexp_replace(text,'[[:cntrl:]]',''),module
  into l_text,l_module
  from logger_logs_5_min
  where id = p_rec.id;

  --dbms_output.put_line('Text: ' || l_text);


  apex_web_service.g_request_headers(1).name := 'Authorization';
  apex_web_service.g_request_headers(1).value := 'Splunk '||l_splunk_hec_token;

               v_body := '{"event": { "logger_text": "'|| l_text ||'",
                          "id": "'||p_rec.id||'",
                          "module": "'||l_module||'"}}';

  if l_splunk_ssl then
    l_http_prefix := 'https';
  end if;
  l_url := l_http_prefix ||'://'||l_splunk_host||':'||l_splunk_port||
    '/services/collector';
   v_result := apex_web_service.make_rest_request(
    p_url            => l_url
   ,p_http_method    => 'POST'
   ,p_body =>  v_body
   );


   --dbms_output.put_line(v_body);
   --dbms_output.put_line(v_result);

end;
/
