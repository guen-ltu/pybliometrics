FROM guenltu/code-fu-devcon:vsc1-ubuntu20.04-python3.10 as base

# linux requirements [optional]
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential

# Python requirements from private GitHub repositories
#RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
#RUN --mount=type=ssh python -m pip --disable-pip-version-check --no-cache-dir install git+ssh://git@github.com/guen-ltu/cfu-utils.git@v0.1.0

# Python requirements
COPY .image/requirements-src.txt /tmp/pip-tmp/requirements-src.txt
RUN python -m pip --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements-src.txt \
    && rm -rf /tmp/pip-tmp

# Python requirements for development
COPY .image/requirements-dev.txt /tmp/pip-tmp/requirements-dev.txt
RUN python -m pip --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements-dev.txt \
    && rm -rf /tmp/pip-tmp

# Python requirements for visual studio code
COPY .image/requirements-vscode.txt /tmp/pip-tmp/requirements-vscode.txt
RUN python -m pip --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements-vscode.txt \
    && rm -rf /tmp/pip-tmp


ENV PYTHONPATH=/home/vscode/workspace

USER vscode


# --------- for development
FROM base as dev

CMD while sleep 1000; do :; done


# --------- for deployment
# no image deployment
