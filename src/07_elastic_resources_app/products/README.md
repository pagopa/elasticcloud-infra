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
    │     └── dashboards # application dashboards. use "${data_view}" placeholder instead of the data_view_id, ${apm_data_view} instead of 'apm_static_index_pattern_id'
    │         ├── ActivationNearToPaymentTokenExpiration.ndjson # saved object format
    │         ├── DeadLetterDashboard.ndjson
    │         ├── NodoFaultCode.ndjson
    │         ├── NpgMonitoringDashboard.ndjson
    │         └── UpdateStatusDashboard.ndjson
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
- **if needed**, create a folder for your dashboards named `dashboard`. Save here all the exported dashboard in ndjson format. **NB:** replace the `data_view_id` value with `"${data_view}"` and `apm_static_index_pattern_id` or `apm_static_index_pattern_id_<your-env>`with `"${apm_data_view}"` to make it dynamic
- **if needed**, create a folder for your saved queries named `query`. Save here all the exported queries in ndjson format
- **required & needs approval**, define the index lifecycle policy to be used for your indexes in `env/<your_env>` variable file, variable `ilm`. Add here a new entry with your application identifier adn the ilm to use, choosing between one of the provided ilm in the `default_library/ilm` folder
- **if needed**, add your application instance name in the `06_elastic_resources_common/env/<your_env>` `k8s_application_log_instance_names` variable if that application is supposed to be monitored using **elastic agent**

### appSettings.json

The appSettings content relies on the contents of `default_library` folder in order to reuse components definitions; in this file you will be referencing the file names 
from the `default_library` that will be used to define resources for your application

Here's an example of the file content:

```json
{
  "displayName": "Print It ${env}",
  "indexTemplate": {
    "indexPatterns": ["logs-print-payment-notice-*"]
  },
  "dataStream": [
    "logs-print-payment-notice-service",
    "logs-print-payment-notice-generator",
    "logs-print-payment-notice-functions"
  ],
  "dataView": {
    "indexIdentifier": "logs-print-payment-*",
    "runtimeFields": [
      { "name": "faultCode", "runtimeField": { "type": "keyword", "script": {"source": "String message = params[\"_source\"][\"message\"];def m = /^.*title=(.*)(?=, status).*$/.matcher(message);if ( m.matches() ) {return emit(m.group(1));} else{return emit(\"-\");}"}}},
      { "name": "faultDetail", "runtimeField": { "type": "keyword", "script": {"source": "String message = params[\"_source\"][\"message\"];\n\ndef m = /^.*detail=(.*)(?=\\)).*$/.matcher(message);\nif ( m.matches() ) {\n   return emit(m.group(1));\n} else {\n   return emit(\"-\");\n}"}}}
    ]
  },
  "apmDataView": {
    "indexIdentifiers": [
      "print-payment"
    ]
  },
  "customComponent": "basic-pipeline-lifecycle@custom",
  "packageComponent": "kubernetes-agent@package",
  "ingestPipeline": "convert_responseTime_httpCode"
}
```

where:

- `displayName`: **required** Human readable name used in some resources for this application
- `indexTemplate`: **required** structure containing the following fields   
  - `indexPatterns`: **required** list of patterns used to identify the indexes for this application. **NB:** the `elastic_namespace` variable will be appended to every pattern
- `dataStream`: **required** list of data stream names that will be created for this application. **NB:** the `elastic_namespace` variable will be appended to that
- `dataView`: **required** structure containing the following fields
  - `indexIdentifier`: **required** identifier of the indexes to be collected in the data view for this application. **NB:** the `elastic_namespace` variable will be appended to that
  - `runtimeFields`: **optional** list of runtime field definitions
    - `name`: **required** name of the runtime field
    - `runtimeField`: **required** runtime field definition (as exported from kibana)
      - `type`: **required** type of the runtime field; [docs here](https://www.elastic.co/guide/en/elasticsearch/reference/current/runtime-mapping-fields.html)
      - `script`: **required** runtime field source code;  [docs here](https://www.elastic.co/guide/en/elasticsearch/reference/current/runtime-mapping-fields.html)
- `apmDataView`: **optional, with default**, stucture defining how to create the APM data view for this application
  - `indexIdentifiers`: **required**, list of index identifiers used to create the data view; they will be appended to the default identifiers with a trailing `*`: eg: `traces-apm*print-payment*,apm-*print-payment*`
  By default it's `"traces-apm*,apm-*,traces-*.otel-*,logs-apm*,apm-*,logs-*.otel-*,metrics-apm*,apm-*,metrics-*.otel-*"`
- `customComponent`: **optional, with default** component name from the `index_component` library, noted with `@custom` to be attached to the index template. If not defined, the default `basic-only-lifecycle@custom` will be used.
- `packageComponent`: **optional** component name from the `index_component` library, noted with `@package` to be attached to the index template.
- `ingestPipeline`: **required** ingest pipeline name, from the `ingest_pipeline` library, to be attached to the index template

## FAQ

### Need a different ingest pipeline or component or ilm?

If you require a different ingest pipeline definition or a different index component definition, feel free to open a PR defining the new content; @pagopa/payments-cloud-admin will be glad to review it
