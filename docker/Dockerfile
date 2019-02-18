FROM debian:stretch

# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y --no-install-recommends install curl lsb gnupg wget openssh-server openssl ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

# Install FUSE so we can mount GCS buckets
# Ref: https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/installing.md
RUN echo "deb http://packages.cloud.google.com/apt gcsfuse-stretch main" > /etc/apt/sources.list.d/gcsfuse.list
RUN curl -o /tmp/apt-key.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    apt-key add /tmp/apt-key.gpg && rm -f /tmp/apt-key.gpg
RUN apt-get update && apt-get install -y --no-install-recommends gcsfuse && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1001 sftponly && groupadd --gid 1002 passwordonly

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
