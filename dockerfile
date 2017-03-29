FROM python:latest
EXPOSE 8000
RUN pip install mkdocs
RUN mkdocs new content
WORKDIR /content
ENTRYPOINT ["mkdocs"]

#docker build --tag proactis/mkdocs:1 .
#docker run -it -v //C/proactis-documentation/documentation-source:/content  -p 8001:8000 proactis/mkdocs:1 serve -a 0.0.0.0:8000
#docker run -it -v //C/proactis-documentation/documentation-source:/content  -p 8001:8000 proactis/mkdocs:1 build




