def restoreNuget() {
    def output = powershell(script:"c:/Jenkins/nuget.exe restore c:/Jenkins/workspace/Bankdata.test.pipeline/WebApplication1.sln", returnStdout:true)
    return output
}

return this