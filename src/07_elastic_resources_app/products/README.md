# kibana space configuration

This folder contains the configuration used to create, for each monitored product, all the necessary elasticsearch resources to handle the logs:
- kibana spaces
- dashboards
- saved queries
- index lifecycle policy
- data streams
- index templates
- ingest pipeline
- data view

This is the folder structure:

```hcl
config
└── pagopa # product 1 folder
    ├── ecommerce # kibana space folder
    │ └── ecommerce # application folder
    │     ├── appSettings.json # application configuration
    │     ├── dashboard # application dashboards. use "${data_view}" placeholder instead of the data_view_id, ${apm_data_view} instead of 'apm_static_index_pattern_id'
    │     │   ├── ActivationNearToPaymentTokenExpiration.ndjson # saved object format
    │     │   ├── DeadLetterDashboard.ndjson
    │     │   ├── NodoFaultCode.ndjson
    │     │   ├── NpgMonitoringDashboard.ndjson
    │     │   └── UpdateStatusDashboard.ndjson
    │     └── alert # application 1 alerts
    │         └── myalert.yml # alert definition
    ├── ndp # another kibana space
    │ ├── nodo # application 1
    │ │ ├── appSettings.json # application 1 configuration
    │ │ ├── dashboard
    │ │ │ ├── Global.ndjson
    │ │ │ ├── Monitor_Activate_senza_SPO.ndjson
    │ │ │ ├── Monitor_EC.ndjson
    │ │ │ ├── Monitor_EC_Applicativo.ndjson
    │ │ │ ├── Monitor_Invio_SPO_a_Token_Scaduto.ndjson
    │ │ │ ├── Monitor_Tempi_pspNotifyPayment.ndjson
    │ │ │ └── Monitor_Tempi_pspNotifyPayment_sendPaymentOutcome.ndjson
    │ │ └── query # application 1 saved queries
    │ │     └── filter_re_jsonlog.ndjson
    │ ├── nodocron # application 2 (no dahboards, no queries)
    │ │ └── appSettings.json # application 2 configuration
    │ ├── nodocronreplica # application 3
    │ │ └── appSettings.json # application 3 configuration
    ├── p4pa # product 2 folder
    │ └── [...] # same structure
    [...] # other products
```
When applying the terraform script on a target (let's say "pagopa-dev") only the corresponding **product** folder will be read and the configured resources will be created.
The `<env>` part of the target is used in the resource creation process to distinguish between different environments in the same deployment (see `04_elastic_deployment/README.md` )

## How to configure an application

First of all you need to create the correct folder structure, starting from the product folder your application belongs to:

- **if needed**, create a folder for your desired kibana space; the name of the folder will be the name of the kibana space, prepended to the `<env>` tag (i.e.: myspace-dev). Use an existing folder otherwise to create objects attached to that space
- **required**,  create a folder for your application, the folder name will be used as an identifier in the ES resource creation process, so **it must be unique within the product folder**
- **required**, create a file names `appSettings.json`, otherwise no resources will be created
- **if needed**, create a folder for your dashboards named `dashboard`. Save here all the exported dashboard in ndjson format. **NB:** replace the `data_view_id` value with `"${data_view}"` and `apm_static_index_pattern_id` or `apm_static_index_pattern_id_<your-env>`with `"${apm_data_view}"` to make it dynamic. The `${namespace}` variable, containing the elastic namespace such as `pagopa.dev`, can be used to define custom index patterns (used in `ES|QL` queries)
- **if needed**, create a folder for your saved queries named `query`. Save here all the exported queries in ndjson format
- **if needed**, create a folder for your alerts `alert`. Save here all the alert definition in yml format (see alert paragraph for more details)
- **required & needs approval**, define the index lifecycle policy to be used for your indexes in `env/<your_env>` variable file, variable `ilm`. Add here a new entry with your application identifier adn the ilm to use, choosing between one of the provided ilm in the `default_library/ilm` folder
- **if needed**, add your application instance name in the `08_elastic_resources_integration/env/<your_env>` `k8s_application_log_instance_names` variable if that application is supposed to be monitored using **elastic agent**

### appSettings.json

The appSettings content relies on the contents of `default_library` folder in order to reuse components definitions; in this file you will be referencing the file names 
from the `default_library` that will be used to define resources for your application

Here's an example of the file content:

```json
{
  "displayName": "Print It",
  "indexTemplate": {
    "printit": {
      "indexPatterns": [
        "logs-printit"
      ],
      "customComponent": "basic-pipeline-lifecycle@custom",
      "ingestPipeline": "convert_responseTime_httpCode"
    }
  },
  "dataStream": [
    "logs-printit"
  ],
  "dataView": {
    "indexIdentifiers": [ "logs-printit" ]
  }
}
```

where:

- `displayName`: **required** Human readable name used in some resources for this application
- `indexTemplate`: **required** map of index templates to be defined. The _key_ is the unique name of the index template for this application, the _value_ is the following  
  - `indexPatterns`: **required** list of patterns used to identify the indexes for this application. **NB:** the `elastic_namespace` variable will be appended to every pattern
  - `customComponent`: **optional, with default** component name from the `index_component` library, noted with `@custom` to be attached to the index template. If not defined, the default `basic-only-lifecycle@custom` will be used.
  - `packageComponent`: **optional** component name from the `index_component` library, noted with `@package` to be attached to the index template.
  - `ingestPipeline`: **required** ingest pipeline name, from the `ingest_pipeline` library, to be attached to the index template
- `dataStream`: **required** list of data stream names that will be created for this application. **NB:** the `elastic_namespace` variable will be appended to that
- `dataView`: **required** structure containing the following fields
  - `indexIdentifiers`: **required** List of index identifiers to be collected in the data view for this application. **NB:** the `elastic_namespace` variable will be appended to that
  - `runtimeFields`: **optional** list of runtime field definitions
    - `name`: **required** name of the runtime field
    - `runtimeField`: **required** runtime field definition (as exported from kibana)
      - `type`: **required** type of the runtime field; [docs here](https://www.elastic.co/guide/en/elasticsearch/reference/current/runtime-mapping-fields.html)
      - `script`: **required** runtime field source code;  [docs here](https://www.elastic.co/guide/en/elasticsearch/reference/current/runtime-mapping-fields.html)
- `apmDataView`: **optional, with default**, stucture defining how to create the APM data view for this application
  - `indexIdentifiers`: **required**, list of index identifiers used to create the data view; they will be appended to the default identifiers with a trailing `*`: eg: `traces-apm*print-payment*,apm-*print-payment*`
  By default it's `"traces-apm*,apm-*,traces-*.otel-*,logs-apm*,apm-*,logs-*.otel-*,metrics-apm*,apm-*,metrics-*.otel-*"`


## How to configure `k8s_application_log_instance_names`

This variable is a map of `elastic_data_stream_name` and `namespace_or_pod_name` to be used by the elastic agent to collect logs from the application.
The data stream name must match the name used in the application `appSettings.json` file, while the namespace or pod name must be the one used in the application deployment.
All the logs collected from the `namespace_or_pod_name` will be directed to the same `elastic_data_stream_name`


Example: 

`appSettings.json`
```json
{
  "displayName": "eCommerce",
  "indexTemplate": {
    "ecommerce": {
      "indexPatterns" : [
        "logs-ecommerce" # index pattern matching the data stream name (or multiple data stream if necessary)
      ],
      "customComponent": "basic-pipeline-lifecycle@custom",
     "ingestPipeline": "convert_responseTime_httpCode"
    }
  },
  "dataStream": [
    "logs-ecommerce" # data stream where the logs will be sent (plus "logs-" prefix
  ],
  "dataView": {
    "indexIdentifiers": [
      "logs-ecommerce" # index pattern to be included in the data view
    ]
  }

}
```

`k8s_application_log_instance_names`
        
```hcl
k8s_application_log_instance_names = {
  ecommerce = [ # the data stream name
    "pagopaecommerceeventdispatcherservice-microservice-chart",
    "pagopaecommercepaymentmethodsservice-microservice-chart",
    "pagopaecommercepaymentrequestsservice-microservice-chart",
    "pagopaecommercetransactionsservice-microservice-chart",
    "pagopaecommercetxschedulerservice-microservice-chart",
    "pagopanotificationsservice-microservice-chart"
  ]
}
```


This configuration will send all the logs for the microservices listed in "ecommerce" to the "logs-ecommerce" data stream, they wil be affected by the same ingest pipeline and index lifecycle policy
If different ingest pipeline or index lifecycle policy are needed, you need to create a new data stream with a different name and configure the application accordingly


## How to configure alerts

If you want to create alerts for your application, you need to create a folder named `alert` in your application folder and add the alert definition in yml format.

Here's an example of the alert definition:

```yaml
name: Redis error
schedule: 5m
window:
  size: 5
  unit: m
# -----------------   
# use this to create an alert on apm traces with anomaly detection  
apm_metric:
  filter: "service.name: pagopa-gpd-core"
  metric: anomaly
  anomaly:
    service: "pagopa-gpd-core"
    detectors:
      - latency
      - throughput
      - failures
    severity_type: critical  
# -----------------     
# use this to create an alert on apm traces to monitor a specific metric with a threshold    
apm_metric:
  filter: "service.name: pagopa-gpd-core"
  metric: failed_transactions
  threshold: 10  
# ----------------- 
# use this to create an alert on logs (or apm) data view with a KQL query
log_query:
  aggregation:
    type: sum
    field: "http_code"
  query: "log.level: \"ERROR\" AND error.message: \"Redis command timed out\""
  data_view: logs
  exclude_hits_from_previous_run: true
  threshold:
    values:
      - 10
    comparator: ">"
# ----------------- 
# use this to create an alert on logs (or apm) data view with a custom threshold calculation
custom_threshold:
  data_view: apm
  query: labels.updateTransactionStatus_type:"AUTHORIZATION_OUTCOME"
  aggregations:
    - name: A
      aggregation: count
    - name: B
      aggregation: count
      filter: "NOT labels.updateTransactionStatus_gateway_outcome : (OK or EXECUTED)"
  equation: "(B/A)*100"
  label: "Error Rate"
  threshold:
    values:
      - 10
    comparator: ">"
  group_by:
    - "labels.updateTransactionStatus_paymentMethodTypeCode"
  alert_on_no_data: false  
# -----------------    
trigger_after_consecutive_runs: 3
enabled: true #optional, default true. overrides global value
notification_channels:
  opsgenie:
    connector_name: team-core-opsgenie
    priority: P1
  email:
    recipient_list_name: team-core-emails
  slack:
    connector_name: team-core-slack
  cloudo:
    connector_name: "my-cloudo-connector-name"
    type: "aks"
    attributes:
        namespace: "api-config"
```

where:

**common properties**
- `name`: **required** name of the alert
- `schedule`: **required** schedule for the alert to be executed. It can be a cron expression or a duration (e.g. `5m` for every 5 minutes)
- `window`: **required** time window evaluated by the alert. It can be a duration
    - `size`: **required** size of the time window
    - `unit`: **required** unit of the time window, it can be `m`, `h`, `d` or `w`
- `trigger_after_consecutive_runs`: **optional** number of consecutive runs after which the alert will be triggered
- `enabled`: **optional** if set to `false`, the alert will be disabled. Default is `true`
---
**log query properties**
- `log_query`: **optional** if set, the alert will use the log query to filter the logs. Mutually exclusive with `apm_metric`
  - `aggregation`: **required** aggregation to be applied on query results. 
    - `type`: **required** type of the aggregation, it can be 'count', 'sum', 'avg', 'min', 'max'
    - `field`: **optional** Required if the `aggregation.type` is not `count`. The field to be used for the aggregation
  - `query`: **required** KQL query to be executed on the data view
  - `data_view`: **required** data view to be used for the alert. It can be `logs` or `apm`, depending on where your application sends the logs
  - `exclude_hits_from_previous_run`: **required** if set to `true`, the alert will exclude hits from the previous run, so it will only consider new hits
  - `threshold`: **required** threshold for the alert to be triggered. 
    - `values`: **required** list of values used by the comparator. Multiple values accepted for range comparators
    - `comparator`: **required** comparator to be used for the threshold, it can be '>', '>=', '<', '<=', 'between', 'notBetween'
---
**apm metric properties**
- `apm_metric`: **optional** if set, the alert will use the APM metric to filter the logs. Mutually exclusive with `log_query`
  - `filter`: **optional** KQL filter to be applied on the APM data view
  - `metric`: **required** metric to be used for the alert. Must be one of: 'latency' 'failed_transactions' 'anomaly' 'error_count'
  - `threshold`: **optional** threshold considered by this alert. Not used when `metric` is `anomaly`
  - `anomaly`: **optional** if set, the alert will use the anomaly detection to be triggered
    - `service`: **required** service name to be used for the anomaly detection
    - `detectors`: **required** list of detectors to be used for the anomaly detection. Alowed values: 'latency', 'throughput', 'failures'
    - `severity_type`: **required** severity type to be used for the anomaly detection. One of "critical", "major", "minor", "warning"
---
**custom threshold properties**
- `data_view`: **required** data view to be used for the alert. It can be `logs` or `apm`, depending on where your application sends the logs of if it sends traces
- `query`: **required** KQL query to be executed on the data view, applied to all aggregations
- `aggregations`: **required** list of aggregations to be used for the alert
  - `name`: **required** name of the aggregation, used in the equation
  - `aggregation`: **required** type of the aggregation, it can be 'count', 'sum', 'avg', 'min', 'max', 'cardinality', 
  - `field`: **optional** Required if the `aggregation` is not `count`. The field to be used for the aggregation
  - `filter`: **optional** allowed only in `count` aggregations. KQL filter to be applied to this aggregation only in addition to the main query, allowed only to 'count' aggregations
- `equation`: **required** equation to be used to calculate the final value for the alert. Use the aggregation names defined above
- `label`: **required** label for the calculated value, used in the alert message
- `threshold`: **required** threshold for the alert to be triggered. 
    - `values`: **required** list of values used by the comparator. Multiple values accepted for range comparators
    - `comparator`: **required** comparator to be used for the threshold, it can be '>', '>=', '<', '<=', 'between', 'notBetween'
- `group_by`: **optional** list of fields to be used to group the results
- `alert_on_no_data`: **optional** if set to `true`, the alert will be triggered if no data is found for the query. Default is `true`
---
**notification channels**
- `notification_channels`: **optional** list of notification channels to be used for the alert.
  - `opsgenie`: **optional** if you want to send the alert to OpsGenie, you need to specify the connector name and the priority of the alert
    - `connector_name`: **required** name of the OpsGenie connector to be used for the alert
    - `priority`: **required** priority of the alert, it can be `P1`, `P2`, `P3`, `P4` or `P5`.
  - `email`: **optional** if you want to send the alert to an email address
    - `recipient_list_name`: **required** name of the recipient list to be used for the email notification
  - `slack`: **optional** if you want to send the alert to a Slack channel, you need to specify the connector name
    - `connector_name`: **required** name of the OpsGenie connector to be used for the alert
  - `cloudo`: **optional** if you want to trigger a runbook automation using ClouDO for this alert
    - `connector_name`: **required** name of the webhook (to ClouDO) connector to be used for the alert
    - `type`: **required** type of the ClouDO runbook to be triggered. It can be `aks`
    - `rule`: **required** rule identifier for the ClouDO runbook
    - `attributes`: **optional** map of attributes to be sent to ClouDO
      - `namespace`: **required** namespace where the application is deployed
### An important note on alert notification_channels

The notification channels are defined on the alert file, but this does not mean that on every environment the same notification channels will be used.
This configuration is merged with the `var.alert_channels` variable and will be evaluated only if the channel is enabled; so that only the channels enabled on a specific environment will be used.
If your application does not use a channel at all (in any environment), the corresponding notification channel from the alert file can be removed

Example;

`var.alert_channels`
```hcl
alert_channels = {
    email    = true
    slack    = false
    opsgenie = false
    cloudo   = false
}
```

`alert.yml`
```yaml
[...]
notification_channels:
  opsgenie:
    connector_name: "my-opsgenie-connector-name"
    priority: P1
  slack:
    connector_name: "my-slack-connector-name"
  cloudo:
    connector_name: "my-cloudo-connector-name"
    type: "aks"
    attributes:
        namespace: "application-namespace"
```

In the above case the only enabled channel is `email`, but the alert does not define it, so the alert will not be sent to any channel.
The other channels `slack`and `opsgenie` defined in the alert file are disabled for that environment, so they will not be used.
IF the email notification chanel was defined in the alert file, it would be used to send the alert


### Best practices

#### Minimize the number of data streams

The number of data streams should be kept to a minimum, in order to reduce the number of index and shards to be managed, which creates overload on nodes.
So if an application is composed of multiple microservices, make sure to use the same log format in order to be able to use the same ingest pipeline and make the data converge on the same data stream

## FAQ

### Need a different ingest pipeline or component or ilm?

If you require a different ingest pipeline definition or a different index component definition, feel free to open a PR defining the new content; @pagopa/payments-cloud-admin will be glad to review it
