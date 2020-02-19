// Config
class Globals {
   static String GitRepo = '<path-to-repo>'
<%
   "static String ModuleName = $PLASTER_PARAM_Name"
%>
   static String GoogleChatRoomNotifyUrl = 'https://chat.googleapis.com/v1/spaces/AAAABeHM4ps/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=Z-ocTb9Zu-QCUM-rEPBVxTCBLqI9S34AVDPuAX5GtUo%3D'
}

// Workflow Steps
node('master') {
  try {
    notifyBuild('STARTED')

    stage('Stage 0: Clone') {
      git url: Globals.GitRepo
    }
    stage('Stage 1: InstallDependencies') {
      posh 'Invoke-Build InstallDependencies'
    }
    stage('Stage 2: Clean') {
      posh 'Invoke-Build Clean'
    }
    stage('Stage 3: Test') {
      posh 'Invoke-Build Test'
    }
    stage('Stage 3: Analyze') {
      posh 'Invoke-Build Analyze'
    }
    stage('Stage 4: Publish') {
      timeout(20) {
        posh 'Invoke-Build Publish'
      }
    }

  } catch (e) {
    currentBuild.result = "FAILED"
    throw e
  }
}

// Helper function to run PowerShell Commands
def posh(cmd) {
    bat 'powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "& ' + cmd + '"'
}