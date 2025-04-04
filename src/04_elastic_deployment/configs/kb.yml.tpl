# https://www.elastic.co/guide/en/kibana/current/secure-reporting.html#grant-user-access
xpack.reporting.roles.enabled: false
xpack.security.authc.providers:
%{ for prefix_env, data in shared_env }
  saml.${prefix_env}:
    order: ${data.index}
    realm: ${prefix_env}
    description: "Log in with Azure AD ${upper(prefix_env)}"
%{ endfor ~}
