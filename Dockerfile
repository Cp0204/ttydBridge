FROM tsl0922/ttyd:alpine

ADD /app /app

RUN chmod +x /app/run.sh

WORKDIR /app

ENV EXEC_DIR="/opt"
ENV START_COMMAND="login"
ENV PORT="2222"
ENV ALLOW_WRITE="true"

EXPOSE 2222

ENTRYPOINT ["/app/run.sh", "start"]