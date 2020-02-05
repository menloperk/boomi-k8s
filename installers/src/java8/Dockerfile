FROM arm64v8/ubuntu

ENV DEBIAN_FRONTEND noninteractive

# Install Java.
RUN add-apt-repository -y ppa:webupd8team/java && apt-get update && apt-get install -y unzip debconf-utils wget && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && apt-get install -y oracle-java8-installer && apt-get install -y oracle-java8-unlimited-jce-policy
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

# Define commonly used JAVA_HOME variable
ENV JDK_HOME /usr/lib/jvm/java-8-oracle
ENV JRE_HOME ${JDK_HOME}/jre
ENV JAVA_HOME ${JRE_HOME}
ENV JAVA_ENDORSED_DIRS ${JDK_HOME}/lib/endorsed
ENV JAVA_OPTS "-Xms256m -Xmx2048m -XX:MaxPermSize=1024m -Djava.endorsed.dirs=${JAVA_ENDORSED_DIRS}"
ENV PATH .:${JRE_HOME}/bin:${JDK_HOME}/bin:${PATH}

WORKDIR /
# Define default command.
CMD ["bash"]
