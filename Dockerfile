FROM python:3-alpine

RUN apk add bash git
RUN pip install mkdocs
RUN pip install mkdocs
RUN pip install mkdocs-material
RUN pip install mkdocs-markdownextradata-plugin
RUN pip install md-condition
RUN pip install markdown-fenced-code-tabs
RUN pip install mkdocs-mermaid2-plugin
#RUN mkdocs new infoware

#EXPOSE 8000

#WORKDIR /infoware

#ENTRYPOINT ["mkdocs"]

#CMD ["serve", "--dev-addr=0.0.0.0:8000"]
