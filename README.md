# Project Setup and Deployment Guide

This guide provides step-by-step instructions for setting up and deploying the application using Docker, Jenkins, SonarQube, Trivy, and Kubernetes.

## Phase 1: Docker Setup

### Step: Install Docker and Run the App Using a Container

1. **Set up Docker on the EC2 instance:**

    ```bash
    sudo apt-get update
    sudo apt-get install docker.io -y
    sudo usermod -aG docker \$USER  # Replace with your system's username, e.g., 'ubuntu'
    newgrp docker
    sudo chmod 777 /var/run/docker.sock
    ```

2. **Set the Docker Container Restart Policy:**

    ```bash
    # Use when creating the container:
    docker run -d --restart unless-stopped <image_name>

    # Use when updating an existing container:
    docker update --restart unless-stopped <container_name_or_id>
    ```

3. **Ensure Docker Service Starts on Boot:**

    ```bash
    # Enabled by default, but you can verify
    systemctl is-enabled docker

    # If it’s not enabled, enable it with:
    sudo systemctl enable docker
    ```

## Phase 2: Security

### Step: Install SonarQube and Trivy

1. **Install SonarQube:**

    ```bash
    docker run -d --name sonar -p 9000:9000 sonarqube\:lts-community
    ```

    To access:

    `publicIP:9000` (by default username & password is admin)

2. **Set the Docker Container Restart Policy for SonarQube:**

    ```bash
    # Use when creating the container:
    docker run -d --restart unless-stopped <image_name>

    # Use when updating an existing container:
    docker update --restart unless-stopped <container_name_or_id>
    ```

3. **Install Trivy:**

    ```bash
    sudo apt-get install wget apt-transport-https gnupg lsb-release
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
    echo deb https://aquasecurity.github.io/trivy-repo/deb \$(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install trivy
    ```

4. **Scan Images and Directories Using Trivy:**

    ```bash
    # To scan an image:
    trivy image <imageid>

    # To scan the present directory:
    trivy fs .
    ```

### Step: Integrate SonarQube and Configure

1. **Integrate SonarQube with your CI/CD pipeline.**
2. **Configure SonarQube to analyze code for quality and security issues.**

## Phase 3: CI/CD Setup

### Step: Install Jenkins for Automation

1. **Install Jenkins on the EC2 instance to automate deployment:**

    **Jenkins Prerequisite: Install Java**

    ```bash
    sudo apt update
    sudo apt install fontconfig openjdk-17-jre
    java -version
    ```

    **Install Jenkins:**

    ```bash
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    ```

    - Access Jenkins in a web browser using the public IP of your EC2 instance:

      `publicIp:8080`

### Step: Install Necessary Plugins in Jenkins

1. Go to **Manage Jenkins** → **Plugins** → **Available Plugins** and install the following plugins:
    - SonarQube Scanner (Install without restart)
    - Pipeline View

### Step: Configure SonarQube in Jenkins

1. **Create the SonarQube Token:**

    - Go to **Jenkins Dashboard** → **Manage Jenkins** → **Credentials** → **Add Secret Text**.
    - After adding the SonarQube token, click on **Apply** and **Save**.

2. **Configure System and Global Tool Configuration:**

    - Use the **Configure System** option in Jenkins to configure different servers.
    - Use the **Global Tool Configuration** to configure different tools installed using plugins.
    - Install the SonarQube scanner in the tools.

3. **Create a Jenkins Webhook:**

### Step: Install Docker Tools and Docker Plugins

1. Go to **Dashboard** in your Jenkins web interface.
2. Navigate to **Manage Jenkins** → **Manage Plugins**.
3. Click on the **Available** tab and search for **Docker**.
4. Check the following Docker-related plugins:
    - Docker
    - Docker Commons
    - Docker Pipeline
    - Docker API
    - docker-build-step
5. Click on the **Install without restart** button to install these plugins.

### Step: Add DockerHub Credentials

1. Go to **Dashboard** → **Manage Jenkins** → **Manage Credentials**.
2. Click on **System** and then **Global credentials (unrestricted)**.
3. Click on **Add Credentials** on the left side.
4. Choose **Secret text** as the kind of credentials.
5. Enter your DockerHub credentials (Username and Password) and give the credentials an ID (e.g., "docker").
6. Click **OK** to save your DockerHub credentials.

### Step: Grant Rights for Jenkins Service to Execute Docker Commands

```sh
sudo su
sudo usermod -aG docker jenkins # Adds the Jenkins user to the Docker group
sudo systemctl restart jenkins  # Restart Jenkins Server


# Kubernetes Setup and Cleanup Guide

This guide provides step-by-step instructions for setting up Kubernetes and cleaning up resources.

## Phase 6: Kubernetes

### Prerequisite

- Install `kubectl` from the [Official Documentation](https://kubernetes.io/docs/tasks/tools/).
- [Youtube Reference](https://www.youtube.com/watch?v=G9MmLUsBd3g)

### Set Up: `kubeconfig`

- The `kubeconfig` file contains the connection details and credentials for your Kubernetes cluster. This file is typically located at `~/.kube/config`.
- For Windows: `%USERPROFILE%\.kube\config`

- **Cloud-based Cluster (EKS):**

    ```bash
    aws eks update-kubeconfig --region <region> --name <cluster-name>
    ```

### Create Kubernetes Cluster with Node Groups

In this phase, you'll set up a Kubernetes cluster with node groups. This will provide a scalable environment to deploy and manage your applications.

### Deploy Application with ArgoCD

1. **Install ArgoCD:**

   You can install ArgoCD on your Kubernetes cluster by following the instructions provided in the [EKS Workshop](https://archive.eksworkshop.com/intermediate/290_argocd/install/) documentation.

2. **Set Your GitHub Repository as a Source:**

   After installing ArgoCD, you need to set up your GitHub repository as a source for your application deployment. This typically involves configuring the connection to your repository and defining the source for your ArgoCD application. The specific steps will depend on your setup and requirements.

3. **Create an ArgoCD Application:**

    - `name`: Set the name for your application.
    - `destination`: Define the destination where your application should be deployed.
    - `project`: Specify the project the application belongs to.
    - `source`: Set the source of your application, including the GitHub repository URL, revision, and the path to the application within the repository.
    - `syncPolicy`: Configure the sync policy, including automatic syncing, pruning, and self-healing.

4. **Access your Application:**

   - To access the app through the LoadBalancer address.

## Phase 7: Cleanup

### Step: Cleanup AWS EC2 Instances

- Terminate AWS EC2 instances that are no longer needed.
