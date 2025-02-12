xpack.security.authc.realms:
%{ for prefix_env, data in shared_env }
    saml.${prefix_env}:
        order: ${2 + data.index}
        attributes.principal: nameid
        attributes.groups: "http://schemas.microsoft.com/ws/2008/06/identity/claims/groups"
        attributes.name: "https://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
        idp.metadata.path: "https://login.microsoftonline.com/${tenant_id}/federationmetadata/2007-06/federationmetadata.xml?appid=${data.client_id}"
        idp.entity_id: "https://sts.windows.net/${tenant_id}/"
        sp.entity_id: "api://${prefix_env}-elasticcloud"
        sp.acs: "${kibana_url}/api/security/saml/callback"
        sp.logout: "${kibana_url}/logout"
%{ endfor ~}
