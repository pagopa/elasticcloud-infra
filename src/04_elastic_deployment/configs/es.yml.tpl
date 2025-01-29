xpack.security.authc.realms:
%{ for prefix_env, data in shared_env }
    saml.${prefix_env}:
        order: ${2 + data.index}
        attributes.principal: nameid
        attributes.groups: groups
        idp.metadata.path: "https://login.microsoftonline.com/${tenant_id}/federationmetadata/2007-06/federationmetadata.xml?appid=${data.client_id}"
        idp.entity_id: "https://sts.windows.net/${tenant_id}/"
        sp.entity_id: "${kibana_url}"
        sp.acs: "${kibana_url}/api/security/saml/callback"
        sp.logout: "${kibana_url}/logout"
%{ endfor ~}
