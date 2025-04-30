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

### Best practices

#### Minimize the number of data streams

The number of data streams should be kept to a minimum, in order to reduce the number of index and shards to be managed, which creates overload on nodes.
So if an application is composed of multiple microservices, make sure to use the same log format in order to be able to use the same ingest pipeline and make the data converge on the same data stream

## FAQ

### Need a different ingest pipeline or component or ilm?

If you require a different ingest pipeline definition or a different index component definition, feel free to open a PR defining the new content; @pagopa/payments-cloud-admin will be glad to review it
