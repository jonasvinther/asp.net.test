node('windows') {

    def artifactoryServer = Artifactory.server('artifactory')
    
    def artifactoryUploadSpec = """{
        "files": [
            {
                "pattern": "C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/obj/Release/package-${env.BUILD_NUMBER}.zip",
                "target": "nuget"
            }
        ]
    }"""

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        bat ''' \
            "C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin/amd64/MSBuild.exe" \
            C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/WebApplication1.csproj \
            /v:detailed /t:restore;ReBuild;Package /p:Configuration=Release \
        '''
    }

    stage('Deploy') {
        withCredentials([
            string(credentialsId: 'IISURL', variable: 'IISURL'), 
            string(credentialsId: 'IISUSER', variable: 'IISUSER'), 
            string(credentialsId: 'IISPWD', variable: 'IISPWD')]) {
                doDeploy(IISURL, IISUSER, IISPWD)
        }
    }

    stage('Archive') {
        // archiveArtifacts artifacts: 'WebApplication1/obj/Release/Package/*', fingerprint: true
        doCompress()
        artifactoryServer.upload(artifactoryUploadSpec)
    }

}

def doDeploy(IISURL, IISUSER, IISPWD) {
    bat ''' \
        C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/obj/Release/Package/WebApplication1.deploy.cmd \
        /Y "-setParam:name=\'IIS Web Application Name\',value=\'test\'" \
        "/M:%IISURL%" -allowUntrusted /U:%IISUSER% /P:%IISPWD% /A:Basic \
    '''
}

def doCompress() {
    powershell """ \
        Compress-Archive -Path C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/obj/Release/Package/* \
        -DestinationPath C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1/obj/Release/package-${env.BUILD_NUMBER}.zip -Force \
    """
}
