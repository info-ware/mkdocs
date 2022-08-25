FROM python:3-alpine

RUN apk add bash sh git
RUN pip install mkdocs
RUN mkdocs new infoware

EXPOSE 8000

WORKDIR /infoware

ENTRYPOINT ["mkdocs"]

#CMD ["serve", "--dev-addr=0.0.0.0:8000"]
