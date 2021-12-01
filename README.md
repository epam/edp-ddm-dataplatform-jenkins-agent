# dataplatform-jenkins-agent

### Overview
This repository contains Dockerfile and templates for a Jenkins Agent Docker image based on [edp-jenkins-maven-java11-agent](https://hub.docker.com/r/epamedp/edp-jenkins-maven-java11-agent) intended for use with OpenShift.

### Usage
Use this repository to build a Jenkins Agent Docker image for using by Jenkins operator to deploy data model in data platform project.

###### Prerequisites
[Jenkins operator](https://github.com/epmd-edp/jenkins-operator) deployed in Kubernetes cluster.

###### Steps
In order to build an image from the source, perform the following:

Make your changes in Dockerfile. Build a Docker image from the current project directory using the command below:
```bash
docker build . -t dataplatform-jenkins-agent:latest
```
Push the newly created Docker image to your public or private Docker image hub:
```bash
docker push yourdockerhub/dataplatform-jenkins-agent:latest
```
To deploy execute the command below:
```bash
helm upgrade --install dataplatform-jenkins-agent deploy-templates --namespace <your-namespace> --set image.name=<your-image>
```

### Licensing
The dataplatform-jenkins-agent is Open Source software released under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0).
