# PhoneGap Android builder - Docker Image

This [Docker image](https://hub.docker.com/r/tygerbytes/phonegap-android-builder) should contain everything necessary to build an Android apk with [Adobe PhoneGap](https://phonegap.com/), e.g. in a build pipeline on [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/).

## Running locally

* [Install Docker](https://docs.docker.com/install/)
* Pull/run the container: `docker run --rm -it -v $PWD:/work tygerbytes/phonegap-android-builder:latest /bin/bash`

## Azure container job

To use it for an Azure Pipeline [container job](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases), you would add something like this to your YAML build file:

``` yaml
- job: build_android
  displayName: 'Build and deploy Android app'
  timeoutInMinutes: 30
  pool:
    vmImage: 'ubuntu-16.04'
  container: tygerbytes/phonegap-android-builder:latest

  steps:
  - script: printenv
```

### Debugging Azure container jobs

If the build passes locally but fails in the pipeline, remember that scripts executed within an Azure container job are **not run as root**, so you'll need to use `sudo` to run any commands requiring elevation. Fortunately, this docker image has `sudo` built in.

[This post](https://jaylee.org/archive/2019/03/21/azure-devops-wasm-build-container.html) from Jerome Laban was helpful, especially the part where he shows what the agent runs in the container right after starting it:

``` bash
## Try create an user with UID '1001' inside the container.
/usr/bin/docker exec xxxx bash -c "grep 1001 /etc/passwd | cut -f1 -d:"
/usr/bin/docker exec xxxx useradd -m -u 1001 vsts_azpcontainer
## Grant user 'vsts_azpcontainer' SUDO privilege and allow it run any command without authentication.
/usr/bin/docker exec xxxx groupadd azure_pipelines_sudo
/usr/bin/docker exec xxxx usermod -a -G azure_pipelines_sudo vsts_azpcontainer
/usr/bin/docker exec xxxx su -c "echo '%azure_pipelines_sudo ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

```

* **TIP1**: This repo includes a script called `simulate-azure.sh`, which starts the container and runs the above commands on it, then drops you in an interactive bash shell running as **vsts_azpcontainer**. Just clone this repo and run the script.
* **TIP2**: See the exact commands the Azure build agent is running by queuing up a diagnostic build. See Microsoft's [troubleshooting guide](https://docs.microsoft.com/en-us/azure/devops/pipelines/troubleshooting?view=azure-devops#get-logs-to-diagnose-problems) for more details.


## Credits

Inspired by https://github.com/crisnao2/docker-phonegap

