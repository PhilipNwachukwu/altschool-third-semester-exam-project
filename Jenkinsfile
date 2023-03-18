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
                        sh "kubectl apply -f nginx-deployment.yaml"
                        sh "kubectl apply -f nginx-service.yaml"
                    }
                }
            }
        }

        // stage("Create an EKS Cluster") {
        //     steps {
        //         script {
        //             dir('deploy/kubernetes/terraform') {
        //                 sh "terraform init"
        //                 sh "terraform apply -auto-approve"
        //             }
        //         }
        //     }
        // }

        stage("Deploy Sock Shop to EKS") {
            steps {
                script {
                    dir('deploy/kubernetes') {
                        sh "kubectl create namespace sock-shop"
                        sh "kubectl apply -f complete-demo.yaml"
                    }
                }
            }
        }

        stage("Deploy Grafana and Prometheus to EKS") {
            steps {
                script {
                    dir('deploy/kubernetes') {
                        sh "kubectl create -f ./deploy/kubernetes/manifests-monitoring"
                    }
                }
            }
        }
    }
}