FROM arvados/jobs:latest

USER root

RUN apt-get update
RUN apt-get install wget -y
RUN apt-get install python-pip -y
RUN apt-get install python-numpy -y
RUN apt-get install python-scipy -y
RUN apt-get install python-matplotlib -y
RUN apt-get install python-pandas -y
RUN apt-get clean



RUN pip install sklearn
RUN pip install --upgrade scipy
RUN pip install seaborn

FROM rocker/r-base:latest


RUN Rscript /data-sdd/owebb/l7g-ml/Dockerfiles/pythonR/install_packages.R