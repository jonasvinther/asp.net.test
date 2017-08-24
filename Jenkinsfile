pipeline() {
    agent {
        label 'windows'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                script {
                    bat '"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin/amd64/MSBuild.exe" C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/WebApplication1.csproj /v:detailed /t:restore;ReBuild;Package'
                } 
            } 
        }
        stage('Deploy') {
            
            steps {
                withCredentials([
                    string(credentialsId: '', variable: 'IISURL'), 
                    string(credentialsId: '', variable: 'IISUSER'), 
                    string(credentialsId: '', variable: 'IISPWD')
                ]){
                    bat 'C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/obj/Debug/Package/WebApplication1.deploy.cmd /Y "-setParam:name=\'IIS Web Application Name\',value=\'test\'" "/M:${IISURL}" -allowUntrusted /U:${IISUSER} /P:${IISPWD} /A:Basic'
                }
            }
        }
    }
}
