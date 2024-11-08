pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_TAG', description: 'Enter the image tag')
        string(name: 'APP_NAME', description: 'Enter the APP_NAME')
    }
    environment {
        GIT_REPO = "https://github.com/askyourmentors/webinar-code-to-cloud-conf.git" 
        REPO_NAME = "webinar-code-to-cloud-conf"
        GIT_CREDENTIAL_ID = "github"
        EMAIL = "akif22inbox@gmail.com"
    }

    stages{

        stage('CLEANUP WORKSPACE'){
            steps{
                script{
                    cleanWs()
                }
            }
        }

        stage("CHECKOUT GIT REPO"){
            steps{
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage("UPDATE K8S DEPLOYMENT FILES AND PUSH TO THE GIT REPO"){
            steps{

                sh 'cat ./k8s-manifests/deployment.yaml'
                sh "sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' ./k8s-manifests/deployment.yaml"
                sh 'cat ./k8s-manifests/deployment.yaml'
                sh 'git add ./k8s-manifests/deployment.yaml'
                sh "git commit -m 'Updated deployment files to ${IMAGE_TAG}'"

                withCredentials([usernamePassword(credentialsId: env.GIT_CREDENTIAL_ID, passwordVariable: 'pass', usernameVariable: 'uname')]) {
                    sh 'git config --global user.email $EMAIL'
                    sh 'git config --global user.name $uname'
                    sh 'git push https://$uname:$pass@github.com/$uname/$REPO_NAME.git main'
                }
            }
        }
    }
}