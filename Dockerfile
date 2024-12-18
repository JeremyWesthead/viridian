# FROM ubuntu:20.04

# ENV DEBIAN_FRONTEND=noninteractive
# ENV PATH=/bioinf-tools/:/bioinf-tools/enaBrowserTools/python3/:$PATH
# ENV LANG=C.UTF-8

# ARG VIR_WF_DIR=/viridian
# RUN mkdir -p $VIR_WF_DIR/.ci/
# COPY .ci/install_dependencies.sh $VIR_WF_DIR/.ci/install_dependencies.sh
# RUN $VIR_WF_DIR/.ci/install_dependencies.sh /bioinf-tools

# COPY . $VIR_WF_DIR

# Build stage
# Install build dependencies, build the package
FROM ubuntu:20.04 AS builder


ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/bioinf-tools/:/bioinf-tools/enaBrowserTools/python3/:$PATH
ENV LANG=C.UTF-8

ARG VIR_WF_DIR=/viridian
RUN mkdir -p $VIR_WF_DIR/.ci/
COPY .ci/install_dependencies.sh $VIR_WF_DIR/.ci/install_dependencies.sh
COPY . $VIR_WF_DIR
RUN $VIR_WF_DIR/.ci/install_dependencies.sh /bioinf-tools

# COPY . $VIR_WF_DIR


FROM python:3.10-slim-buster
RUN apt update && apt install -y git

COPY --from=builder /viridian /viridian
COPY --from=builder /bioinf-tools /bioinf-tools
COPY . /viridian
RUN cp /bioinf-tools/exporting_executables/* /usr/bin
RUN cd /viridian \
  && bash .ci/install_mummer.sh \
  && ls -lhat \
  && pip install ".[dev]" \
  && pytest

CMD viridian

