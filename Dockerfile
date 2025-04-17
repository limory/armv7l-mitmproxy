# syntax = docker/dockerfile:experimental
FROM python AS build

ARG TAG=latest
ENV PATH="/cargo/bin:${PATH}"
RUN --mount type=tmpfs,destination=/abc,tmpfs-options=inode=32 && cat /proc/mounts|grep tmpfs
RUN --security=insecure mkdir -p /cargo && chmod 777 /cargo && mount -t tmpfs -o inode=32 none /cargo && \
	cat /proc/mounts|grep cargo && \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
	pip wheel --wheel-dir=/wheels mitmproxy$([[ ${TAG} != "latest" ]] && echo "==${TAG}" || echo "") && \
    	find /root/.cache/pip/wheels -type f -name "*.whl" -exec cp {} /wheels \;&& \
	pip --no-cache-dir install --no-index --find-links=/wheels mitmproxy && \
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
