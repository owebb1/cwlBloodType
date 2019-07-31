FROM arvados/jobs:latest

USER root

RUN apt-get update
RUN apt-get -y install r-cran-rcpp r-cran-data.table libapt-pkg-dev less
RUN apt-get install wget -y
RUN apt-get install python-pip -y
RUN apt-get install python-numpy -y
RUN apt-get install python-scipy -y
RUN apt-get install python-matplotlib -y
RUN apt-get install python-pandas -y
RUN apt-get -y dist-upgrade
RUN apt-get clean

RUN R -e "install.packages('glmnet', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('Matrix', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('reticulate', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('foreach', repos = 'http://cran.us.r-project.org')"




RUN pip install sklearn
RUN pip install --upgrade scipy
RUN pip install seaborn
