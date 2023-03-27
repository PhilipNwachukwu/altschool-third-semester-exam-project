#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-west-2"
        // SockShopFrontEnd = "sockshop.philipnwachukwu.ml"
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }

        stage("Deploy Storageclass") {
            steps {
                script {
                    dir('eks-sc') {
                        // sh "aws eks update-kubeconfig --name altschlapp-eks-aerJO6YM"
                        // sh 'kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"'
                        sh 'kubectl apply -f ebs-sc.yaml'
                        sh "kubectl patch storageclass gp2 -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"false\"}}}'"
                        sh "kubectl patch storageclass ebs-sc -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"true\"}}}'"                
                    }  
                }
            }
        }

        stage("Deploy to EKS-Cluster") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "kubectl apply -f fineract-namespace.yaml"
                        sh "kubectl apply -f fineract-deployment.yaml"
                        sh "kubectl apply -f fineract-service.yaml"
                    }
                }
            }
        }

        stage("Deploy Sock Shop to EKS") {
            steps {
                script{
                    dir('sock-shop') {
                        sh "kubectl apply -f namespace-sockshop.yaml"
                        // sh 'bash ./deploy-sockshop-aws-eks.sh'
                        // sh 'read -p 'fqdnOfSockShopFrontEnd ' fqdnOfSockShopFrontEnd <<< "$SockShopFrontEnd"'
                        // sh 'cd $HOME/workspace/Sock-Shop-deployment-pipeline/sock-shop/'
                        sh 'cp ./sslcert.conf.sample ./sslcert.conf'
                        sh 'sed -i "s/fqdnOfSockShopFrontEnd/$fqdnOfSockShopFrontEnd/g" ./sslcert.conf'
                        sh 'cp ./ingress-sockshop.yaml.sample ./ingress-sockshop.yaml'
                        sh 'sed -i "s/fqdnOfSockShopFrontEnd/$fqdnOfSockShopFrontEnd/g" ./ingress-sockshop.yaml'
                        sh "openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout tls.key -out tls.crt -config sslcert.conf -extensions 'v3_req'"
                        // kubectl create secret tls sockshop-tls -n sock-shop --key tls.key --cert tls.crt
                        // Converting secret creation to YAML for supporting ArgoCD/GitOps
                        sh 'kubectl create secret tls sockshop-tls -n sock-shop --key tls.key --cert tls.crt --dry-run=client --output=yaml > sockshop-tls.yaml'
                        sh 'kubectl apply -f sockshop-tls.yaml'
                        sh 'kubectl apply -f ./ingress-controllers/admission-service-account.yaml'
                        sh 'kubectl apply -f ./ingress-controllers/validating-webhook.yaml'
                        sh 'kubectl apply -f ./ingress-controllers/jobs.yaml'
                        sh 'kubectl apply -f ./ingress-controllers/ingress-service-account.yaml'
                        sh 'kubectl apply -f ./ingress-controllers/configmap.yaml'
                        sh 'kubectl apply -f ./ingress-controllers/services.yaml'
                        sh 'kubectl apply -f ./ingress-controllers/deployment.yaml'
                        // sh 'kubectl apply -f ./ingress-controllers/nginx-ingress-controller-eks-nlb.yaml'
                        sh 'kubectl apply -f ./ingress-controllers/nginx-ingress-class.yaml'
                        sh 'cp complete-demo-with-persistence.yaml complete-demo-with-persistence-aws.yaml'
                        sh "sed -i 's/powerstore-ext4/ebs-sc/g' complete-demo-with-persistence-aws.yaml"
                        sh "sed -i 's/8Gi/1Gi/g' complete-demo-with-persistence-aws.yaml"
                        sh 'kubectl apply -f complete-demo-with-persistence-aws.yaml'
                        // sh 'kubectl apply -f complete-demo.yaml'
                        // sh 'kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission'
                        sh 'kubectl apply -f ingress-sockshop.yaml'
                    }
                }
                        
            }
        }

        // stage("Deploy monitoring and alerting to EKS") {
        //     steps {
        //         script {
        //             dir('deploy/kubernetes/grafana') {
        //                 sh "terraform init -upgrade"
        //                 sh "terraform apply -auto-approve"
        //                 // sh 'kubectl apply -f manifests-monitoring/namespace-monitoring.yaml'
        //                 // sh 'kubectl apply -f manifests-monitoring/prometheus-grafana.yaml'
        //                 // sh 'kubectl apply -f manifests-alerting/alertmanager.yaml'
        //                 // sh 'kubectl apply -f manifests-logging/kibana.yaml'
        //                 // sh "kubectl port-forward --address 0.0.0.0 -n prometheus deploy/prometheus-server 8001:9090"
        //                 // sh "kubectl port-forward --address 0.0.0.0 -n grafana deploy/grafana 8001:3000"
        //             }
        //         }
        //     }
        // }
    }

}
