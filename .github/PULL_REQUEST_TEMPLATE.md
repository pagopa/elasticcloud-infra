<!--- Please always add a PR description as if nobody knows anything about the context these changes come from. -->
<!--- Even if we are all from our internal team, we may not be on the same page. -->
<!--- Write this PR as you were contributing to a public OSS project, where nobody knows you and you have to earn their trust. -->
<!--- This will improve our projects in the long run! Thanks. -->

### New application definition checklist

Checklist based on the documentation provided [here](https://github.com/pagopa/elasticcloud-infra/blob/main/src/07_elastic_resources_app/products/README.md) 


- [ ] Created a new application folder
- [ ] Defined `appSettings.json`
- [ ] Defined the index lifecycle management policy for your app 
- [ ] If using elastic agent: defined your service name in `08_elastic_resources_integration/env/<target>-<env>/terraform.tfvars` => `k8s_application_log_instance_names` variable

For any detail refer to the documentation linked above

### Apply in your environment

Once finished with your pr, you can apply the changes in your environment by running the appropriate pipeline in the correct order:
the order is determined by the folder name, both on the project and the pipeline folder structure

**[Here is the link to the pipelines](https://dev.azure.com/pagopaspa/paymon-iac/_build?view=folders)**



### List of changes

<!--- Describe your changes in detail -->

### Motivation and context

<!--- Why is this change required? What problem does it solve? -->

### Type of changes

- [ ] Add new resources
- [ ] Update configuration to existing resources
- [ ] Remove existing resources

### Does this introduce a change to production resources with possible user impact?

- [ ] Yes, users may be impacted applying this change
- [ ] No

### Does this introduce an unwanted change on infrastructure? Check terraform plan execution result

- [ ] Yes
- [ ] No

### Other information

<!-- Any other information that is important to this PR such as screenshots of how the component looks before and after the change. -->

---

### If PR is partially applied, why? (reserved to mantainers)

<!--- Describe the blocking cause -->
