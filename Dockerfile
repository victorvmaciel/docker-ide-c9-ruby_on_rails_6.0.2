FROM linuxserver/cloud9

ENV RUBY_VERSION 2.7.1
ENV RAILS_VERSION 6.0.2.2

############# certificates install #######################################################

# RUN mkdir /usr/share/ca-certificates/your-cert-folder
# ADD ./your_internet_cert.crt 
# RUN cp -R /usr/share/ca-certificates/your-cert-folder  /usr/local/share/ca-certificates && update-ca-certificates


#############  oracle client #######################################################

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2/
RUN export LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2/
RUN echo 'source /opt/oracle/instantclient_12_2/network/admin/.oracle' >> /etc/bash.bashrc

RUN mkdir -p /opt/oracle/instantclient_12_2/network/admin \
    && apt-get update \
    && apt-get -y  install unzip \
    && apt-get -y  install sudo

ADD ./instantclient-basic-linux.x64-12.2.0.1.0.zip ./instantclient-sdk-linux.x64-12.2.0.1.0.zip ./instantclient-sqlplus-linux.x64-12.2.0.1.0.zip     /opt/oracle/
ADD ./tnsnames.ora   ./.oracle       /opt/oracle/instantclient_12_2/network/admin/


RUN cd /opt/oracle \
 && unzip instantclient-basic-linux.x64-12.2.0.1.0.zip \
 && unzip instantclient-sdk-linux.x64-12.2.0.1.0.zip \
 && unzip instantclient-sqlplus-linux.x64-12.2.0.1.0.zip \
 && cd /opt/oracle/instantclient_12_2 && ln -s libclntsh.so.12.1 libclntsh.so

############# dependencies and softwares ########################################

RUN apt-get -y  install wget \
     && apt-get -y  install curl \
     && apt-get -y  install libcurl4-openssl-dev \
     && apt-get -y  install libpq-dev \
     && apt-get -y  install nano \
     && apt-get -y  install libaio1 \
     && apt-get -y install git

############### nodejs and yarn #########################################################

RUN apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update

RUN apt-get -y install git-core \
zlib1g-dev \
build-essential \
libssl-dev \
libreadline-dev \
libyaml-dev \
libsqlite3-dev \
sqlite3 \
libxml2-dev \
libxslt1-dev \
libcurl4-openssl-dev \
software-properties-common \
libffi-dev \
yarn

RUN yarn config set "strict-ssl" false -g

############### nodejs e yarn ######################################################### 

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.16.1
# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
      && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
      && apt-get update \ 
      && apt-get -y install yarn

############### Install RVM  ############################################################
 
RUN sudo apt install curl \
  && curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && sudo apt-get update \
  && sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

RUN sudo apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
RUN sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB


RUN \curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby

RUN  /bin/bash -l -c "source /usr/local/rvm/scripts/rvm"
RUN  /bin/bash -l -c "rvm install $RUBY_VERSION"
RUN  /bin/bash -l -c "rvm use $RUBY_VERSION --default"
RUN  /bin/bash -l -c "rvm requirements"
RUN  /bin/bash -l -c "rvm rubygems current"
RUN  /bin/bash -l -c "gem install sprockets -v 3.7.2" 
RUN  /bin/bash -l -c "gem install rails --version=$RAILS_VERSION"
RUN  /bin/bash -l -c "gem install bundler"
RUN sudo chmod 777 -R  /usr/local/rvm/ #Permissão para dar o bundle com usuário abc
