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
def branch_name
def github_clone_url
def project_workspace_path
pipeline {
    agent {label 'master'}
    stages {
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
	       GITHUB_CLONE_URL = props['github_clone_url']
	       BRANCH_NAME = props['branch_name']
	       PROJECTWORKSPACEPATH = props['project_workspace_path']
	    }
	  }
	}
      stage("JpetStore") {
	    steps {
                     jenkinsCode(
	                GITHUB_CLONE_URL: "${GITHUB_CLONE_URL}",
		        BRANCH_NAME: "${BRANCH_NAME}",
			SONAR_PROJECT_KEY: "${SONAR_PROJECT_KEY}",
			SONAR_JAVA_BINARIES: "${SONAR_JAVA_BINARIES}",
			SONAR_LANGUAGE: "${SONAR_LANGUAGE}",
		        SONAR_PROJECT_NAME: "${SONAR_PROJECT_NAME}",
		        PROJECT_WORKSPACE_PATH: "${PROJECTWORKSPACEPATH}",
			ARTIFACTORY_NAME: "${ARTIFACTORY_NAME}",
			ARTIFACT_ID: "${ARTIFACT_ID}",
			GROUP_ID: "${GROUP_ID}",
			PACKAGING_TYPE: "${PACKAGING_TYPE}",
			ARTIFACT_VERSION: "${ARTIFACT_VERSION}",
			APP_NAME: "${APP_NAME}",
			APP_LOCAL_PATH: "${APP_LOCAL_PATH}",	
		    )
		}
	  }
    }
}
