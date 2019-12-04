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

## Post-install

Ansible AWX includes process isolation by default for playbook runs (jobs). This cannot be accomplished inside of a container, which already has process isolation. Thus, you can turn off Job Isolation by following the instructions below:

> **Disabling bubblewrap support:**
> To disable bubblewrap support for running jobs (playbook runs only), ensure you are  logged in as the Admin user and click on the settings gear settings in the upper right-hand corner. Click on the “Configure Tower” box, then click on the “Jobs” tab. Scroll down until you see “Enable Job Isolation” and change the radio button selection to “off”.

## Values

[see values.yaml](./values.yaml)
