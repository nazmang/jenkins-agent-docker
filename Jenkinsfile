pipeline {
    agent {label 'jnlp-agent-docker'}

    environment {
        // Telegram configre
        TOKEN = credentials('telegramToken')
        CHAT_ID = credentials('telegramChatid')

        // Telegram Message Success and Failure
        TEXT_SUCCESS_BUILD = "${JOB_NAME} is Success"
        TEXT_FAILURE_BUILD = "${JOB_NAME} is Failure"

        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub' 
        DOCKER_HUB_REPO = 'nazman' 
        IMAGE_NAME = 'inbound-agent-docker' 
        GIT_REPO_URL = 'https://github.com/nazmang/jenkins-agent-docker.git' 
        GIT_BRANCH = 'main' 
        
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
                    dockerImage.tag("latest")

                    // Login to Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', env.DOCKER_HUB_CREDENTIALS_ID) {
                        // Push the Docker image to Docker Hub
                        dockerImage.push()
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }

    post {
        success {
            script{
                sh "curl --location --request POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' --form text='${TEXT_SUCCESS_BUILD}' --form chat_id='${CHAT_ID}'"
            }
        }
        failure {
            script{
                sh "curl --location --request POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' --form text='${TEXT_FAILURE_BUILD}' --form chat_id='${CHAT_ID}'"
            }
        }
    }
}
