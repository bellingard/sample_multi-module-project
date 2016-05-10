#!/bin/sh

# This assumes that the 2 following variables are defined:
# - SONAR_HOST_URL => should point to the public URL of the SQ server (e.g. for Nemo: https://nemo.sonarqube.org)
# - SONAR_TOKEN    => token of a user who has the "Execute Analysis" permission on the SQ server

installSonarQubeScanner() {
	export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-2.6
	rm -rf $SONAR_SCANNER_HOME
	mkdir -p $SONAR_SCANNER_HOME
	curl -sSLo $HOME/.sonar/sonar-scanner.zip http://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/2.6/sonar-scanner-cli-2.6.zip
	unzip $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/
	rm $HOME/.sonar/sonar-scanner.zip
	export PATH=$SONAR_SCANNER_HOME/bin:$PATH
}

# Install the SonarQube Scanner
installSonarQubeScanner

# And run the analysis
# It assumes that there's a sonar-project.properties file at the root of the repo
if [ "${TRAVIS_PULL_REQUEST}" != "false" ] 
then
	# This will analyse the PR and display found issues as comments in the PR, but it won't push results to the SonarQube server
	echo "Starting Pull Request analysis by SonarQube..."
	sonar-scanner \
		-Dsonar.host.url=$SONAR_HOST_URL \
		-Dsonar.login=$SONAR_TOKEN \
		-Dsonar.analysis.mode=preview \
		-Dsonar.github.login=$GITHUB_LOGIN \
		-Dsonar.github.oauth=$GITHUB_TOKEN \
		-Dsonar.github.repository=bellingard/multi-language-test \
		-Dsonar.github.pullRequest=$TRAVIS_PULL_REQUEST
else
	# This will run a full analysis of the project and push results to the SonarQube server
	echo "Starting full analysis by SonarQube..."
	sonar-scanner \
		-Dsonar.host.url=$SONAR_HOST_URL \
		-Dsonar.login=$SONAR_TOKEN
fi
