#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-west-2"
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }

        stage("Deploy to EKS-Cluster") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --name altschoolapp-eks-cluster"
                        // sh "kubectl apply -f namespace-nginx.yaml"
                        // sh "kubectl apply -f nginx-deployment.yaml"
                        // sh "kubectl apply -f nginx-service.yaml"
                    }
                }
            }
        }

        stage("Create sockshop namespace") {
            steps {
                script {
                    dir('sock-shop') {
                        sh "kubectl apply -f namespace-sockshop.yaml"
                    }
                }
            }

        }
        stage("Deploy Sock Shop to EKS") {
            steps {
                        sh '''./sock-shop/deploy-sockshop-aws-eks.sh'''
                    }
                }

    //     stage("Deploy monitoring and alerting to EKS") {
    //         steps {
    //             script {
    //                 dir('deploy/kubernetes') {
    //                     sh "kubectl apply -f manifests-monitoring/namespace-monitoring.yaml"
    //                     sh "kubectl apply -f manifests-monitoring/prometheus-grafana.yaml"
    //                     sh "kubectl apply -f manifests-alerting/alertmanager.yaml"
    //                     sh "kubectl apply -f manifests-logging/kibana.yaml"
    //                     sh "kubectl port-forward --address 0.0.0.0 -n prometheus deploy/prometheus-server 8001:9090"
    //                     sh "kubectl port-forward --address 0.0.0.0 -n grafana deploy/grafana 8001:3000"
    //                 }
    //             }
    //         }
    //     }
    // }
   }
}
