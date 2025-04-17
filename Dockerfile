# syntax = docker/dockerfile:experimental
FROM python AS build

ARG TAG=latest
ENV PATH="/root/.cargo/bin:${PATH}"
RUN --security=insecure mkdir -p /root/.cargo && chmod 777 /root/.cargo && mount -t tmpfs none /root/.cargo && \
	cat /proc/mounts|grep tmpfs && \
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
