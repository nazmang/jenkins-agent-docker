pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'nazman' 
        IMAGE_NAME = 'inbound-agent-docker' 
        GIT_REPO_URL = 'https://github.com/nazmang/jenkins-agent-docker.git' 
        GIT_BRANCH = 'main' 
        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub' 
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository and switch to the specified branch
                checkout([$class: 'GitSCM',
                          branches: [[name: "${env.GIT_BRANCH}"]],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          userRemoteConfigs: [[url: "${env.GIT_REPO_URL}"]]])
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def buildDate = new Date().format('yyyyMMdd') // Get the current date
                    def buildNumber = currentBuild.number // Get the build number

                    // Build the Docker image with a tag in the format YYYYMMDD-build_number
                    def dockerImage = docker.build("${env.DOCKER_HUB_REPO}/${env.IMAGE_NAME}:${buildDate}-${buildNumber}")

                    // Add the 'latest' tag to the image
                    dockerImage.tag("${env.DOCKER_HUB_REPO}/${env.IMAGE_NAME}:latest")

                    // Login to Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', env.DOCKER_HUB_CREDENTIALS_ID) {
                        // Push the Docker image to Docker Hub
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
