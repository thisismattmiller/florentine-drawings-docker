
# we are using the java 8 image as our base
FROM    openjdk:8-jre

# apt update and install lsof for solr
RUN apt-get update && \
  apt-get -y install lsof

# make our home dir
RUN mkdir /home/florentinedrawings
WORKDIR /home/florentinedrawings

# add in the start script from the git repo
ADD scripts/start.sh .

# downlaod/extract solr
RUN wget https://archive.apache.org/dist/lucene/solr/5.5.2/solr-5.5.2.tgz
RUN tar zxvf solr-5.5.2.tgz

RUN rm solr-5.5.2.tgz

# install git
RUN apt-get -y install git-core
RUN git config --global user.name "florentinedrawings"
RUN git config --global user.email florentinedrawings@example.com

# get the rails and solr config repos cloned
RUN git clone https://github.com/villaitatti/florentine-drawings-solr-config.git
RUN git clone https://github.com/villaitatti/florentine-drawings.git


# install ruby and rails
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io -o rvm.sh
RUN cat rvm.sh | bash -s stable --rails

# install the right version of ruby and bundle install the app
RUN bash -c "source /usr/local/rvm/scripts/rvm \
    && rvm install 2.2.0 \
    && cd florentine-drawings \
    && bundle install"

EXPOSE 80

# the entry point for the docker
CMD ["/bin/bash", "start.sh"]