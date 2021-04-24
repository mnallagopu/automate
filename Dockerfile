FROM jenkins/jenkins:lts-centos
USER root
RUN dnf update -y && dnf install -y 'dnf-command(config-manager)' && \
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo && \
dnf list docker-ce && \
dnf update && \
dnf install docker-ce --nobest -y && \
dnf clean all
EXPOSE 8080
#EXPOSE 8080:8090
RUN usermod -a -G docker jenkins
#RUN echo '%docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER admin
ENV JENKINS_PASS admin
COPY plugins.txt /usr/share/jenkins/ref/
COPY addjobs/ /usr/share/jenkins/ref/addjobs/
USER root
RUN chmod 777 -R /usr/share/jenkins/ref/addjobs
USER jenkins

# COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

#RUN sleep 100
#CMD ["/bin/bash"]
#USER root
#RUN while curl 'localhost:8080';do echo waiting for missingfile;done
#WORKDIR /usr/share/jenkins/ref/addjobs/
#RUN bash gradlew rest --stacktrace -DbaseUrl=http://localhost:8080 -Dpattern=jobs/simple.groovy -Dusername=admin -Dpassword=admin
#RUN ./gradlew rest --stacktrace -DbaseUrl=http://localhost:8080 -Dpattern=jobs/simple.groovy -Dusername=admin -Dpassword=admin
#USER jenkins
#CMD /bin/bash
