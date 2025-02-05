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
    │     └── dashboards # application dashboards. use "${data_view}" placeholder instead of the data_view_id
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
- **if needed**, create a folder for your dashboards named `dashboard`. Save here all the exported dashboard in ndjson format. **NB:** replace the `data_view_id` value with `"${data_view}"` to make it dynamic
- **if needed**, create a folder for your saved queries named `query`. Save here all the exported queries in ndjson format

### appSettings.json

Here's an example of the file content:

```json
{
  "displayName": "Print It ${env}",
  "indexTemplate": {
    "indexPattern" : "logs-print-payment-notice-*"
  },
  "dataStream": [
    "logs-print-payment-notice-service",
    "logs-print-payment-notice-generator",
    "logs-print-payment-notice-functions"
  ],
  "dataView": {
    "indexIdentifier": "print-payment"
  },
  "customComponent": "basic-pipeline-lifecycle@custom",
  "packageComponent": "kubernetes-agent@package",
  "ingestPipeline": "convert_responseTime_httpCode"
}
```
