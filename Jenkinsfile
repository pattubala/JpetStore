def props
def sonar_project_key
def sonar_java_binaries
def sonar_language
def sonar_project_name
def artifactory_name
def app_local_path
def artifact_id
def group_id
def packaging_type
def artifact_version
def app_name
		
def getRepoURL()
  {
    repositoryUrl = "https://github.com/pattubala/JpetStore.git"
    return repositoryUrl;
  }
def getRepoFolderName()
  {
    repository = getRepoURL();
    String[] repoPathDetails = repository.split("pattubala/");
    folderNameDetails = repoPathDetails[1];
    String[] folderNameArr = folderNameDetails.split(".git");
    repoFolderName = folderNameArr[0];
    return repoFolderName;
  }
def sendEmail()
{
    mailRecipients = "chittisreepadh@gmail.com"
    emailext body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS: Check console output at $BUILD_URL to view the results.''',
    mimeType: 'text/html',
    subject: "${currentBuild.fullDisplayName} - Build ${currentBuild.result}",
    to: "${mailRecipients}",
    replyTo: "${mailRecipients}",
    recipientProviders: [[$class: 'CulpritsRecipientProvider']]
}
pipeline {
    agent {label 'master'}
    environment {
        PROJECT_WORKSPACE_PATH = "/var/lib/jenkins/workspace/${getRepoFolderName().toString().toUpperCase()}/";
    }
    stages {
        stage('Cleanup') {
            steps {
                dir("${PROJECT_WORKSPACE_PATH}"){
                deleteDir()
            }
            }
        }
	stage ('SCM Checkout') {
          steps {
            dir("${PROJECT_WORKSPACE_PATH}"){
            git (url: "${getRepoURL()}",
            branch: 'master',
            credentialsId: 'Github')
           }
          }
        }
	stage ('Input Variables') {
	  steps {
	    script {
	       props = readProperties file:'jenkins-variables.properties'
               GIT_CLONE_URL = props['git_clone_url']
               SONAR_PROJECT_KEY = props['sonar_project_key']
               SONAR_JAVA_BINARIES = props['sonar_java_binaries']
               SONAR_LANGUAGE = props['sonar_language']
               SONAR_PROJECT_NAME = props['sonar_project_name']
	       ARTIFACTORY_NAME = props['artifactory_name']
	       ARTIFACT_ID = props['artifact_id']
	       GROUP_ID = props['group_id']
	       PACKAGING_TYPE = props['packaging_type']
	       ARTIFACT_VERSION = props['artifact_version']
	       APP_NAME = props['app_name']
	    }
	  }
	} 
        stage("SONARQUBE") {
            steps {
                dir("${PROJECT_WORKSPACE_PATH}"){
                script {
				    stage ('Static Code Analysis') {
                        withSonarQubeEnv('Sonarqube_7.6') {
                        sh "mvn sonar:sonar -Dsonar.projectName=${SONAR_PROJECT_NAME} -Dsonar.projectKey=${SONAR_PROJECT_NAME} -Dsonar.java.binaries=${SONAR_JAVA_BINARIES} -Dsonar.language=${SONAR_LANGUAGE} -Dsonar.sourceEncoding=UTF-8"
                        } 
				    }
                    stage('Quality Check') {
                        sleep(60);
                        timeout(time: 1, unit: 'MINUTES') { // If something goes wrong pipeline will be killed after a timeout
                        def qg = waitForQualityGate();
                        if (qg.status != "OK") {
                         currentBuild.result='FAILURE';
                         error "Pipeline aborted due to quality gate coverage failure: ${qg.status}"
                        }
                        else{
                           echo "Quality gate passed: ${qg.status}" 
                        }
                        }
                    }	
                }
            }
          }
		}		
		stage ('Maven Build') {
            steps {
                dir("${PROJECT_WORKSPACE_PATH}"){
                    script {
                      sh "mvn clean install"

		            }
				}
		    }
		}
		stage ('Nexus Upload') {
            steps {
                dir("${PROJECT_WORKSPACE_PATH}"){
                    script {
			    nexusPublisher nexusInstanceId: 'Nexus_3.x', nexusRepositoryId: ${ARTIFACTORY_NAME}, packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: "{APP_LOCAL_PATH}"]], mavenCoordinate: [artifactId: ${ARTIFACT_ID}, groupId: ${GROUP_ID}, packaging: ${PACKAGING_TYPE}, version: ${ARTIFACT_VERSION}]]]

		            }
				}
		    }
		}
		stage ('Deployment') {
            steps {
                dir("${PROJECT_WORKSPACE_PATH}"){
                    script {
			    sh "cp -r ${app_local_path} /var/lib/tomcat8/webapps/${app_name}.war"
		            }
				}
		    }
		}
    }
//Post build action send email in both cases
post {
    success {
        sendEmail();
    }
      
    failure {
        sendEmail();
    }
}
}
