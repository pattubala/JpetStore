@Library('jenkins_library@main') _
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
	       APP_LOCAL_PATH = props['app_local_path']
	    }
	  }
	} 
        stage("SONARQUBE STATIC CODE ANALYSIS") {
            steps {
                dir("${PROJECT_WORKSPACE_PATH}"){
                    codeScan(
			    projectname: "${SONAR_PROJECT_NAME}",
			    projectkey: "${SONAR_PROJECT_KEY}",
			    javabinaries: "${SONAR_JAVA_BINARIES}",
			    language: "${SONAR_LANGUAGE}"
		    )	
                }
            }
          }
        stage("QUALITY GATES CHECK") {
            steps {
                dir("${PROJECT_WORKSPACE_PATH}"){
                     qualityGates()
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
			    nexusPublisher nexusInstanceId: 'Nexus_3.x', nexusRepositoryId: "${ARTIFACTORY_NAME}", packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: "${APP_LOCAL_PATH}"]], mavenCoordinate: [artifactId: "${ARTIFACT_ID}", groupId: "${GROUP_ID}", packaging: "${PACKAGING_TYPE}", version: "${ARTIFACT_VERSION}"]]]
		            }
				}
		    }
		}
		stage ('Deployment') {
            steps {
                dir("${PROJECT_WORKSPACE_PATH}"){
                    script {
			    sh "cp -r ${APP_LOCAL_PATH} /var/lib/tomcat8/webapps/${APP_NAME}.war"
		            }
				}
		    }
		}
    }
}
