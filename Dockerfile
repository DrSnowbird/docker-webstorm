FROM openkbs/jdk-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

ARG INSTALL_DIR=${INSTALL_DIR:-/opt}

####
#### ---- Per product unique vars: change per product ----
## WebStorm-2020.2.3.tar.gz
## https://download.jetbrains.com/webstorm/WebStorm-2018.3.3.tar.gz
## https://download-cf.jetbrains.com/webstorm/WebStorm-2018.3.3.tar.gz
## ./WebStorm-183.5153.33//bin/webstorm.sh
ARG PRODUCT_VER=${PRODUCT_VER:-2020.2.3}


ARG PRODUCT_DOWNLOAD_ROOT=https://download.jetbrains.com
ARG PRODUCT_NAME=WebStorm
#ARG PRODUCT_NAME_LOWER="`echo $PRODUCT_NAME | tr '[:upper:]' '[:lower:]'`"
ARG PRODUCT_NAME_LOWER=webstorm
ARG PRODUCT_EXE_NAME=${PRODUCT_NAME_LOWER}.sh
####
#### ---- Mostly, generic: change only needed ----
ARG PRODUCT_TGZ=${PRODUCT_TGZ:-${PRODUCT_NAME}-${PRODUCT_VER}.tar.gz}
ARG PRODUCT_TGZ_URL=${PRODUCT_URL:-${PRODUCT_DOWNLOAD_ROOT}/${PRODUCT_NAME_LOWER}/${PRODUCT_TGZ}}
ARG PRODUCT_HOME=${INSTALL_DIR}/${PRODUCT_NAME}

ARG PRODUCT_EXE=${PRODUCT_HOME}/bin/${PRODUCT_EXE_NAME}
ENV PRODUCT_EXE=${PRODUCT_EXE}

################################## 
#### ---- Install Target ---- ####
##################################
WORKDIR ${INSTALL_DIR}
USER 0

RUN echo `pwd` && wget -c --no-check-certificate ${PRODUCT_TGZ_URL} && \
    tar xvf $(basename ${PRODUCT_TGZ_URL}) && \
    ls -al ${INSTALL_DIR}

RUN ls -al ${INSTALL_DIR}/WebStorm* && \
    rm -f ${INSTALL_DIR}/${PRODUCT_TGZ} && \
    ln -s ${INSTALL_DIR}/${PRODUCT_NAME}-* ${INSTALL_DIR}/${PRODUCT_NAME} && \
    ls -al ${PRODUCT_HOME} && \
    chown -R ${USER_NAME}:${USER_NAME} ${HOME}
    
## ---- user: developer ----
ENV PATH=${PATH}:${PRODUCT_HOME}
ENV USER=${USER:-developer}

ENV HOME=/home/${USER}

USER "${USER_NAME}"

RUN mkdir -p ${HOME}/workspace ${HOME}/data && \
    ls -al ${HOME} && \
    echo "PRODUCT_EXE=${PRODUCT_EXE}" && \
    ls -al ${PRODUCT_EXE}

VOLUME "${HOME}/data"
VOLUME "${HOME}/workspace"

WORKDIR ${HOME}/workspace

ENTRYPOINT "${PRODUCT_EXE}"

#CMD ["/bin/bash"]
