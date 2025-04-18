# syntax = docker/dockerfile:experimental
FROM python AS build

ARG TAG=10.4.2
ENV PATH="/root/.cargo/bin:${PATH}"
RUN --security=insecure mkdir -p /root/.cargo && chmod 777 /root/.cargo && mount -t tmpfs none /root/.cargo && \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
 	pip install click cryptography pyinstaller && \
	git clone https://github.com/mitmproxy/mitmproxy.git /mitm && cd /mitm && python -u release/build.py standalone-binaries
CMD [ "bash" ]

#FROM debian:stable-slim
#COPY --from=build /root/.mitmproxy /root
#RUN chmod +x /root/.mitmproxy/dist/* && mv /root/.mitmproxy/dist/* /usr/bin && \
#    rm -rf /root/.mitmproxy/dist
    
#VOLUME /root/.mitmproxy
#EXPOSE 8080 8081
#CMD [ "mitmproxy" ]
