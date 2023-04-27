FROM nexus-docker-registry.apps.cicd2.mdtu-ddm.projects.epam.com/epamedp/edp-jenkins-maven-java11-agent:2.0.0

USER root
RUN yum update -y && yum install wget -y && yum install jq -y && rm -rf /var/lib/apt/lists/*
ENV VERIFY_CHECKSUM=false
RUN localedef --no-archive -c -i uk_UA -f UTF-8 uk_UA
ENV LANG=uk_UA.UTF-8
ENV LANGUAGE=uk_UA:uk
RUN ln -s --force /usr/local/bin/helm /sbin/ && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh
COPY pom.xml $HOME/pom.xml
COPY settings.xml $HOME/settings.xml
RUN mkdir $HOME/liquibase && mkdir $HOME/liquibase/lib && mkdir $HOME/service-generation-utility && \
    mkdir $HOME/report-publisher && mkdir $HOME/notification-template-publisher && mkdir $HOME/geoserver-publisher \
    mkdir $HOME/registry-regulations-validator-cli && mkdir $HOME/camunda-auth-cli && mkdir $HOME/form-data-storage-migration-cli && \
    mvn -f $HOME/pom.xml --settings $HOME/settings.xml -Dartifactory.baseUrl=http://nexus:8081/nexus -Dartifactory.groupPath=edp-maven-group -Dartifactory.releasePath=edp-maven-releases -Dartifactory.snapshotsPath=edp-maven-snapshots dependency:copy-dependencies && \
    cp $HOME/target/dependency/liquibase-ddm-ext*.jar $HOME/liquibase/lib/liquibase-ddm-ext.jar && \
    cp $HOME/target/dependency/liquibaserepo*.tar.gz /liquibaserepo-0.0.1.tar.gz && \
    tar -xf /liquibaserepo-0.0.1.tar.gz -C / && \
    cp $HOME/target/dependency/liquibase-core-*.jar $HOME/liquibase/liquibase.jar && \
    cp $HOME/target/dependency/service-generation-utility*.jar $HOME/service-generation-utility/service-generation-utility.jar && \
    cp $HOME/target/dependency/report-publisher*.jar $HOME/report-publisher/report-publisher.jar && \
    cp $HOME/target/dependency/notification-template-publisher*.jar $HOME/notification-template-publisher/notification-template-publisher.jar && \
    mv $HOME/target/dependency/registry-regulations-validator-cli*.jar $HOME/registry-regulations-validator-cli/registry-regulations-validator-cli.jar && \
    cp $HOME/target/dependency/camunda-auth-cli*.jar $HOME/camunda-auth-cli/camunda-auth-cli.jar && \
    cp $HOME/target/dependency/geoserver-publisher*.jar $HOME/geoserver-publisher/geoserver-publisher.jar && \
    cp $HOME/target/dependency/form-data-storage-migration-cli*.jar $HOME/form-data-storage-migration-cli/form-data-storage-migration-cli.jar && \
    wget -O $HOME/liquibase/lib/postgresql-42.3.3.jar "https://jdbc.postgresql.org/download/postgresql-42.3.3.jar"
RUN chown -R "1001:0" "$HOME" && \
    chmod -R "g+rw" "$HOME"
USER 1001