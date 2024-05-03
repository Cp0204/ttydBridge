FROM tsl0922/ttyd:alpine

ADD /app /app

RUN chmod +x /app/run.sh

WORKDIR /app

ENV EXEC_PATH="/opt/ttyd"
ENV START_COMMAND="login"
ENV PORT="2222"

EXPOSE 2222

ENTRYPOINT ["/app/run.sh", "start"]