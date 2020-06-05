# Ansible AWX

https://github.com/ansible/awx

AWX provides a web-based user interface, REST API, and task engine built on top of Ansible. It is the upstream project for Tower, a commercial derivative of AWX.

Add our repo:

```bash
helm repo add adwerx https://adwerx.github.io/charts
```

Install the chart:

```bash
helm install adwerx/awx
```

## Job Isolation and Security Context

Ansible AWX task runners employ a legacy process isolation for playbook runs (jobs) via [bubblewrap](https://github.com/containers/bubblewrap). The purpose of this isolation is [to restrict access to shared AWX subsystems, which could be multi-tenant](https://github.com/ansible/awx/pull/7188#issuecomment-636069719)—access the AWX task pod has and could be exploited. If you are not using AWX in a multi-tenant fashion and trust users writing playbooks to have full access to a Pod in your cluster, you may choose to disable bubblewrap. If you'd like to retain bubblewrap isolation on playbook runs in a kubernetes deployment, you'll need to run the AWX task pods with a priveleged security context (PR welcome).

Per the AWX documentation, if you choose to turn off Job Isolation you can do so by following the instructions below:

> **Disabling bubblewrap support:**
> To disable bubblewrap support for running jobs (playbook runs only), ensure you are  logged in as the Admin user and click on the settings gear settings in the upper right-hand corner. Click on the “Configure Tower” box, then click on the “Jobs” tab. Scroll down until you see “Enable Job Isolation” and change the radio button selection to “off”.

## Values

[see values.yaml](./values.yaml)
