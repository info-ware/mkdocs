FROM debian:buster

RUN apt-get update 
RUN apt-get install -y build-essential devscripts cmake gcc g++ debhelper dh-systemd dh-exec pkg-config libtool autoconf
RUN apt-get install -y git libasound2-dev libgles2-mesa-dev libboost-all-dev bzip2 curl git-core html2text libc6-i386 lib32stdc++6 lib32gcc1 lib32z1 unzip openssh-client sshpass lftp 
RUN apt-get install -y doxygen doxygen-latex graphviz wget ccache joe maven default-jdk binutils-i686-linux-gnu libgnutls28-dev adb 
RUN apt-get install -y qtbase5-dev
RUN apt-get install -y python3-pip

RUN mkdir -m 0750 /root/.android
            
# Correction needed for java certificates
RUN dpkg --purge --force-depends ca-certificates-java
RUN apt-get install -y ca-certificates-java

# clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# ------------------------------------------------------
# --- Android NDK
# ------------------------------------------------------

ENV ANDROID_NDK_VERSION="r18b"
ENV ANDROID_NDK_HOME=/opt/android-ndk

# download
RUN mkdir /opt/android-ndk-tmp
WORKDIR /opt/android-ndk-tmp
RUN wget  https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip

# uncompress
RUN unzip android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
# move to its final location
RUN mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME}
# remove temp dir
RUN rm -rf /opt/android-ndk-tmp

# ------------------------------------------------------
# --- Android SDK
# ------------------------------------------------------
# must be updated in case of new versions set 
#ENV VERSION_SDK_TOOLS="4333796"
ENV VERSION_SDK_TOOLS=6858069
ENV ANDROID_HOME="/sdk"
ENV ANDROID_SDK_ROOT="/sdk"

RUN rm -rf /sdk
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_SDK_TOOLS}_latest.zip -O sdk.zip
RUN unzip sdk.zip -d /sdk 
RUN rm -v sdk.zip

RUN mkdir -p ${ANDROID_HOME}/licenses/ && echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license && echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license

ADD packages.txt /sdk

RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg && ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --update --sdk_root=/sdk 

# accept all licences
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --licenses --sdk_root=/sdk

RUN ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --package_file=/sdk/packages.txt --sdk_root=/sdk


# ------------------------------------------------------
# --- Finishing touch
# ------------------------------------------------------


RUN mkdir /scripts
ADD scripts/get-release-notes.sh /scripts
RUN chmod +x /scripts/get-release-notes.sh

ADD scripts/adb-all.sh /scripts
RUN chmod +x /scripts/adb-all.sh

ADD scripts/compare_files.sh /scripts
RUN chmod +x /scripts/compare_files.sh

ADD scripts/lint-up.rb /scripts
ADD scripts/send_ftp.sh /scripts


# add ANDROID_NDK_HOME to PATH
ENV PATH ${PATH}:${ANDROID_NDK_HOME}

# SETTINGS FOR GRADLE 5.4.1
ADD https://downloads.gradle-dn.com/distributions/gradle-5.4.1-all.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx
RUN cp /tmp/gradle-5.4.1-all.zip /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/
RUN unzip /tmp/gradle-5.4.1-all.zip -d /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/gradle-5.4.1-all.ok
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/gradle-5.4.1-all.lck
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/gradle-5.4.1-all.zip.lck 

ADD https://downloads.gradle-dn.com/distributions/gradle-5.4.1-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x
RUN cp /tmp/gradle-5.4.1-bin.zip /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x/
RUN unzip /tmp/gradle-5.4.1-bin.zip -d /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x/gradle-5.4.1-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x/gradle-5.4.1-bin.lck
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x/gradle-5.4.1-bin.zip.lck


# SETTINGS FOR GRADLE 6.7
ADD https://downloads.gradle-dn.com/distributions/gradle-6.7-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv
RUN cp /tmp/gradle-6.7-bin.zip /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv/
RUN unzip /tmp/gradle-6.7-bin.zip -d /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv
RUN touch /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv/gradle-6.7-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv/gradle-6.7-bin.lck

# SETTINGS FOR GRADLE 6.7.1
ADD https://downloads.gradle-dn.com/distributions/gradle-6.7.1-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6
RUN cp /tmp/gradle-6.7.1-bin.zip /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6/
RUN unzip /tmp/gradle-6.7.1-bin.zip -d /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6
RUN touch /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6/gradle-6.7.1-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6/gradle-6.7.1-bin.lck

ENV GRADLE_HOME=/opt/gradle/gradle-5.4.1/bin

# install selenium + chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install ./google-chrome-stable_current_amd64.deb
RUN python3 -m pip install --upgrade pip
RUN pip install selenium


# add ccache to PATH
ENV PATH=/usr/lib/ccache:${GRADLE_HOME}:${PATH}

ENV CCACHE_DIR /mnt/ccache
ENV NDK_CCACHE /usr/bin/ccache

