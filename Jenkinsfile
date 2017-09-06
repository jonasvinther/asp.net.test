node('windows') {
    try {
        notifyBuild('STARTED')

        def commitId
        def artifactoryServer = Artifactory.server('artifactory')
        def workspacePath = "C:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1"
        def artifactoryApiPath = "http://52.29.11.22:8081/artifactory/api"

        stage('Preparation') {
            checkout scm
            commitId = powershell(script: "git rev-parse HEAD", returnStdout: true).trim()
        }

        stage('Build') {
            powershell "c:/Jenkins/nuget.exe restore c:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1.sln"

            bat """ \
                \"C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools/MSBuild/15.0/Bin/amd64/MSBuild.exe\" \
                ${workspacePath}/WebApplication1.csproj \
                /v:detailed /t:ReBuild;Package /p:Configuration=Release \
            """
        }

        stage('Deploy') {
            withCredentials([
                string(credentialsId: 'IISURL', variable: 'IISURL'), 
                string(credentialsId: 'IISUSER', variable: 'IISUSER'), 
                string(credentialsId: 'IISPWD', variable: 'IISPWD')]) {
                    doDeploy(IISURL, IISUSER, IISPWD, workspacePath)
            }
        }

        stage('Archive') {
            // archiveArtifacts artifacts: 'WebApplication1/obj/Release/Package/*', fingerprint: true
            powershell """ \
                Compress-Archive -Path ${workspacePath}/obj/Release/Package/* \
                -DestinationPath ${workspacePath}/obj/Release/package-${env.BUILD_NUMBER}.zip -Force \
            """
        }

        stage('Upload to artifactory') {
            def artifactoryUploadSpec = """{
                "files": [
                    {
                        "pattern": "${workspacePath}/obj/Release/package-${env.BUILD_NUMBER}.zip",
                        "target": "generic-local/",
                        "props": "commit.id=${commitId};"
                    }
                ]
            }"""

            def buildinfo = artifactoryServer.upload(artifactoryUploadSpec)
            artifactoryServer.publishBuildInfo(buildinfo)
        }

        stage('Move artifact') {
            withCredentials([
                [$class: 'UsernamePasswordMultiBinding', credentialsId: 'artifactory', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']
            ]) {
                def artifactoryBase64AuthInfo = powershell(script: "[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(('{0}:{1}' -f '${USERNAME}','${PASSWORD}')))", returnStdout: true).trim()
                
                powershell """ \
                 Invoke-RestMethod -Headers @{Authorization=('Basic {0}' -f '${artifactoryBase64AuthInfo}')} \
                 -Method POST -UseBasicParsing \
                 -Uri '${artifactoryApiPath}/copy/generic-local/package-${env.BUILD_NUMBER}.zip?to=/production/package-${env.BUILD_NUMBER}.zip' \
                """
            }
        }

    }
    catch (e) {
        // If there was an exception thrown, the build failed
        currentBuild.result = "FAILED"
    } finally {
        // Success or failure, always send notifications
        notifyBuild(currentBuild.result)
    }

}

def doDeploy(IISURL, IISUSER, IISPWD, workspacePath) {
    bat """ \
        ${workspacePath}/obj/Release/Package/WebApplication1.deploy.cmd \
        /Y \"-setParam:name=\'IIS Web Application Name\',value=\'test\'\" \
        \"/M:%IISURL%\" -allowUntrusted /U:%IISUSER% /P:%IISPWD% /A:Basic \
    """
}

def notifyBuild(String buildStatus = 'STARTED') {
    // build status of null means successful
    buildStatus =  buildStatus ?: 'SUCCESSFUL'

    // Default values
    def colorName = 'RED'
    def colorCode = '#FF0000'
    def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def summary = "${subject} <${env.BUILD_URL}|Job URL> - <${env.BUILD_URL}/console|Console Output>"

    // Override default values based on build status
    if (buildStatus == 'STARTED') {
        color = 'YELLOW'
        colorCode = '#FFFF00'
    } else if (buildStatus == 'SUCCESSFUL') {
        color = 'GREEN'
        colorCode = '#00FF00'
    } else {
        color = 'RED'
        colorCode = '#FF0000'
    }

    // Send notifications
    slackSend (color: colorCode, message: summary)
}