#!/bin/bash

echo Before Run wss-container-apply-configurations

# Run wss-container-apply-configurations
# java -jar /etc/usr/local/whitesource/utils/wss-container-apply-configurations-23.1.1-jar-with-dependencies.jar /conf/prop.json
# java -jar /etc/usr/local/whitesource/utils/wss-container-apply-configurations-23.1.1-jar-with-dependencies.jar /etc/usr/local/whitesource/conf/prop.json
java -cp /etc/usr/local/whitesource/utils/wss-container-apply-configurations-23.1.1-jar-with-dependencies.jar:/ com.wss.container.ApplyConfigurations -v /etc/usr/local/whitesource/conf/prop.json

echo After running update-Config-From-Wss-Properties

echo Before running wss-container-prerequisites

# Run wss-container-prerequisites - for example : check proxy
# java -jar /lib/wss-container-prerequisites-23.1.1-jar-with-dependencies.jar /conf/prerequisitesProperties.json

echo After running update-Config-From-Wss-Properties

# Run bolt4bb Application
java $JAVA_OPTS -jar /etc/usr/local/whitesource/bolt-runner-23.6.2-jar-with-dependencies.jar
