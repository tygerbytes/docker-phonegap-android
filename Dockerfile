FROM ubuntu:18.04

ARG GRADLE_VERSION=5.6.2

# Run `docker build --no-cache .` to update dependencies
RUN \
    # Install required tools
    apt-get update --fix-missing && apt-get install -y \
        git \
        sudo \
        curl \
        software-properties-common \
    # Make sudo less annoying
    && sed -i '/secure_path\|env_reset/d' /etc/sudoers \
    # Download and register Microsoft repository GPG keys
    && curl -sL https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -o /tmp/ms-repo-gpg-keys.deb \
    && dpkg -i /tmp/ms-repo-gpg-keys.deb \
    && apt-get update && add-apt-repository universe \
    # Install the goods
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y --no-install-recommends \
        powershell \
        openjdk-8-jre \
        openjdk-8-jdk \
        zip \
        unzip \
        nodejs \
        libxml2-utils \
    && npm -g install phonegap@~9 \
    && curl -L "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/gradle-bin.zip \
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
        zip \
        unzip  \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

ENV GRADLE_HOME /opt/gradle/gradle-${GRADLE_VERSION}
ENV ANDROID_HOME /opt/android/sdk
ENV PATH "${GRADLE_HOME}/bin:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}"
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
