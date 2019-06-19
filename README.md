# docker-phonegap-android

This Docker image should contain everything necessary to build an Android apk with PhoneGap, for example, in a build pipeline on Azure DevOps.

## Running locally

Run this container locally with something like:
`docker run --rm -it -v $PWD:/build tygerbytes/phonegap-android-builder:latest /bin/bash`

## Azure container job

To use it for an Azure Pipeline container job, you would add something like this to your YAML build file:

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

## Credits

Inspired by https://github.com/crisnao2/docker-phonegap

