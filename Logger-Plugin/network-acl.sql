BEGIN
  DBMS_NETWORK_ACL_ADMIN.append_host_ace (
    host       => '*',
    lower_port => 1,
    upper_port => 9999,
    ace        => xs$ace_type(privilege_list => xs$name_list('connect'),
                              principal_name => 'PUBLIC',
                              principal_type => xs_acl.ptype_db));
END;
/
