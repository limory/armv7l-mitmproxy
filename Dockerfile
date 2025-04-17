# syntax = docker/dockerfile:experimental
FROM python AS build

ARG TAG=latest
ENV PATH="/root/.cargo/bin:${PATH}"
RUN --security=insecure mkdir -p /root/.cargo && chmod 777 /root/.cargo && mount -t tmpfs -o inode32 none /root/.cargo && \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
	pip install mitmproxy && \
	pip install pyinstaller && \
	cd /root/.mitmproxy && \
	pyinstaller -F $(which mitmdump) && \
	pyinstaller -F $(which mitmweb) && \
	pyinstaller -F $(which mitmproxy)
 
CMD [ "bash" ]

#FROM debian:stable-slim
#COPY --from=build /root/.mitmproxy /root
#RUN chmod +x /root/.mitmproxy/dist/* && mv /root/.mitmproxy/dist/* /usr/bin && \
#    rm -rf /root/.mitmproxy/dist
    
#VOLUME /root/.mitmproxy
#EXPOSE 8080 8081
#CMD [ "mitmproxy" ]
