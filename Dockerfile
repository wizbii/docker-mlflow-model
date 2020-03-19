FROM continuumio/miniconda3

WORKDIR /app

ENV MLFLOW_TRACKING_URI=http://localhost:5000
ENV HADOOP_HOME /app/hadoop-2.9.2
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV MODEL_FOLDER domain
ENV MODEL_NAME domaine_test

ADD downloader.py downloader.py

RUN mkdir /usr/share/man/man1/
RUN mkdir /data

RUN apt update -y
RUN apt install default-jdk-headless nano wget -y

RUN wget http://archive.apache.org/dist/hadoop/core/hadoop-2.9.2/hadoop-2.9.2.tar.gz
RUN tar -xvzf hadoop-2.9.2.tar.gz
RUN cp hadoop-2.9.2/lib/native/libhdfs.so hadoop-2.9.2/

RUN pip install mlflow pyarrow

CMD mlflow models serve -h 0.0.0.0 --install-mlflow -m "$(python downloader.py)"/$MODEL_FOLDER
