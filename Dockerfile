FROM alpine/git

RUN mkdir /msales /repo && \
    apk --update add git openssh curl wget && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

ADD entry.sh /msales/entry.sh

RUN chmod 755 /msales && \
    chmod 644 /msales/* && \
    chmod +x /msales/entry.sh && \
    wget -O /tmp/helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-linux-amd64.tar.gz && \
    tar --strip 1 -C /usr/bin -zxf /tmp/helm.tar.gz linux-amd64/helm && \
    chown root. /usr/bin/helm && \
    chmod 755 /usr/bin/helm && \
    rm /tmp/helm.tar.gz

EXPOSE 8879

ENTRYPOINT ["/msales/entry.sh"]
