// pipeline() {
//     agent {
//         label 'windows'
//     }
    
//     stages {
//         stage('Checkout') {
//             steps {
//                 checkout scm
//             }
//         }
//         stage('Build') {
//             steps {
//                 script {
//                     bat '"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin/amd64/MSBuild.exe" C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/WebApplication1.csproj /v:detailed /t:restore;ReBuild;Package /p:Configuration=Release'
//                 } 
//             } 
//         }
//         stage('Deploy') {
            
//             steps {
//                 withCredentials([
//                     string(credentialsId: 'IISURL', variable: 'IISURL'), 
//                     string(credentialsId: 'IISUSER', variable: 'IISUSER'), 
//                     string(credentialsId: 'IISPWD', variable: 'IISPWD')]) {
//                         bat 'C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/obj/Release/Package/WebApplication1.deploy.cmd /Y "-setParam:name=\'IIS Web Application Name\',value=\'test\'" "/M:%IISURL%" -allowUntrusted /U:%IISUSER% /P:%IISPWD% /A:Basic'
//                 }
//             }
//         }
//     }
// }

node('windows') {

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        bat '"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin/amd64/MSBuild.exe" C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/WebApplication1.csproj /v:detailed /t:restore;ReBuild;Package /p:Configuration=Release'
    }

    stage('Deploy') {
        withCredentials([
            string(credentialsId: 'IISURL', variable: 'IISURL'), 
            string(credentialsId: 'IISUSER', variable: 'IISUSER'), 
            string(credentialsId: 'IISPWD', variable: 'IISPWD')]) {
                bat 'C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/obj/Release/Package/WebApplication1.deploy.cmd /Y "-setParam:name=\'IIS Web Application Name\',value=\'test\'" "/M:%IISURL%" -allowUntrusted /U:%IISUSER% /P:%IISPWD% /A:Basic'
        }
    }

}