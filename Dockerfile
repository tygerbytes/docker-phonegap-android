FROM ubuntu:18.04

# Install required tools
# Run `docker build --no-cache .` to update dependencies
RUN apt-get update && apt-get install -y \
        git \
        sudo \
        curl \
    && sed -i '/secure_path\|env_reset/d' /etc/sudoers \
    && apt-get install -y --no-install-recommends \
        openjdk-8-jre \
        openjdk-8-jdk \
        zip \
        unzip \
        nodejs \
        npm \
        libxml2-utils \
    && npm -g install phonegap@~8 \
    && curl -L https://services.gradle.org/distributions/gradle-5.5.1-bin.zip -o /tmp/gradle-bin.zip \
    && mkdir -p /opt/gradle && unzip -d /opt/gradle /tmp/gradle-*.zip \
    && curl -L https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -o /tmp/sdk.zip \
    && mkdir -p /opt/android/sdk && unzip -d /opt/android/sdk /tmp/sdk.zip \
    && yes | /opt/android/sdk/tools/bin/sdkmanager --licenses \
    && /opt/android/sdk/tools/bin/sdkmanager --install \
        "platform-tools" \
        "build-tools;29.0.2" \
        "platforms;android-27" \
        "platforms;android-28" \
        "platforms;android-29" \
    && apt-get remove -y \
        curl \
        zip \
        unzip  \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

ENV GRADLE_HOME /opt/gradle/gradle-5.4.1
ENV ANDROID_HOME /opt/android/sdk
ENV PATH "${GRADLE_HOME}/bin:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}"
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

