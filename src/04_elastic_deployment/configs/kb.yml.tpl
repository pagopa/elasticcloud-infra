%{ for prefix_env in shared_env }
xpack.security.authc.providers:
  saml.${prefix_env}:
    order: 0
    realm: ${prefix_env}
    description: "Log in with Azure AD ${prefix_env}"
%{ endfor ~}
