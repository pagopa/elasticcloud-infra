prefix         = "pagopa"
env_short      = "s"
env            = "staging"
location       = "westeurope"
location_short = "weu"

kv_name_org_ec           = "paymon-u-ec-org-kv"
kv_rg_org_ec             = "paymon-u-ec-org-sec-rg"
elastic_apikey_env_short = "u"
elastic_apikey_env       = "uat"

default_ilm_logs       = "w1-c3-d5"
default_ilm_traces     = "w1-c3-d5"
default_ilm_metrics    = "w1-c3-d5"
default_ilm_elastic    = "w1-c3-d5"
default_ilm_metricbeat = "w1-c3-d5"

ilm_delete_wait_for_snapshot = false

deployment_name = "pagopa-s-weu-ec"

alert_channels = {
    log = true
    slack = true
    email = false
    opsgenie = false
}