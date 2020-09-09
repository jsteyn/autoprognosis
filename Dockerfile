#Download base image ubuntu 18.04
FROM ubuntu:18.04

LABEL maintainer="jannetta.steyn@newcastle.ac.uk"

ENV TZ=Europe/London

# Update Ubuntu Software repository
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install apt-utils
RUN apt-get -y install cmake vim python3.6 python3.6-dev python3-pip wget git apt-transport-https software-properties-common zip unzip libpaper-utils xdg-utils liblas3 libcairo2 libcurl4 libjpeg8 liblapack3 libpango-1.0-0 libpangocairo-1.0-0 libpng16-16 libtiff5 libtk8.6 libxt6 gfortran libblas-dev libatlas-base-dev liblapack-dev libatlas-base-dev libncurses5-dev libreadline-dev libjpeg-dev libpcre3-dev libpng-dev zlib1g-dev libbz2-dev liblzma-dev libicu-dev pkg-config r-base-core r-base-dev jupyter jupyter-core jupyter-notebook
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
RUN apt-get update
RUN apt-get upgrade -y

## COPY ALL AutoPrognosis files
COPY autoprognosis/ /autoprognosis/
COPY init/ /init/
COPY util/ /util/
COPY requirements.txt /autoprognosis/.
COPY install_packages.r /autoprognosis/.

## COPY DATA FILES
COPY spambase.csv /autoprognosis/spambase.csv
# https://www.kaggle.com/uciml/breast-cancer-wisconsin-data
COPY kaggle_breastcancer.csv /autoprognosis/kaggle_breastcancer.csv
RUN ls -la /

## INSTALL ALL THINGS R
RUN cd /autoprognosis
RUN Rscript /autoprognosis/install_packages.r

## INSTALL ALL THINGS PYTHON
RUN pip3 install cython jupyter jupyter-core notebook pivottablejs GPyOpt pandas numpy
RUN pip3 install matplotlib tqdm rpy2 xgboost==1.0.1 scikit-learn==0.21.1 ipywidgets==7.1
RUN python3 -m pip install tensorflow 

## INSTALL ALL THINGS JUPYTER
RUN mkdir /root/.jupyter
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
# RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
COPY jupyter_notebook_config.py /root/.jupyter/.

# Run command to keep container running
CMD cd /autoprognosis; jupyter notebook --port=8080 --no-browser --ip=0.0.0.0 --allow-root

