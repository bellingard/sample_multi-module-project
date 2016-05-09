#!/bin/sh

# This assumes that the 2 following variables are defined:
# - SONAR_HOST_URL => should point to the public URL of the SQ server (e.g. for Nemo: https://nemo.sonarqube.org)
# - SONAR_TOKEN    => token of a user who has the "Execute Analysis" permission on the SQ server

runAnalysis() {
	# Install SQ Scanner
	export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner
	rm -rf $SONAR_SCANNER_HOME
	mkdir -p $SONAR_SCANNER_HOME
	curl -sSL http://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/2.6/sonar-scanner-cli-2.6.zip | bsdtar zx --strip-components 1 -C $SONAR_SCANNER_HOME

	# And run the analysis - assumes that there's a sonar-project.properties file at the root of the repo
	sonar-scanner -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_TOKEN
}

runAnalysis
