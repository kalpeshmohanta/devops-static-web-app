pipeline {
    agent any
    
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace') {
            steps {
                cleanWs() // Clean the Jenkins workspace
                sh "docker system prune -f" // Clean up unused Docker objects
            }
        }
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/kalpeshmk/static-web-app.git'
            }
        }
        stage("Sonarqube Analysis") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Static-Web-App \
                    -Dsonar.projectKey=Static-Web-App'''
                }
            }
        }
        stage("quality gate") {
            steps {
                script {
                    // Waits for SonarQube analysis results
                    // Uses 'sonar-token' credentials for authentication
                    // Won't stop pipeline if quality checks fail
                    try {
                        timeout(time: 1, unit: 'MINUTES') {
                            waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                        }
                    } 
                    catch (Exception e) {
                        // Continue the pipeline even if Quality Gate fails
                        echo "Quality Gate failed or timed out: ${e}"    
                    }
                }
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){   
                       sh "docker build -t app-image ."
                       sh "docker tag app-image kalpeshmohanta/app-image:${BUILD_NUMBER}"
                       sh "docker push kalpeshmohanta/app-image:${BUILD_NUMBER}"
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image kalpeshmohanta/app-image:${BUILD_NUMBER} > trivyimage.txt" 
            }
        }
        
    }
}