FROM python:latest
EXPOSE 8000
RUN pip install mkdocs
RUN mkdocs new content

# Setup mkdocs to pandoc
# RUN apt-get update
# RUN apt-get install -y fonts-lmodern
# RUN apt-get install lmodern
# RUN apt-get install -y pandoc
# RUN apt-get install -y texlive-base
# RUN apt-get install -y texlive-latex-extra
# RUN apt-get install -y texlive-fonts-recommended
# RUN apt-get install -y texlive-latex-recommended
# RUN apt-get install -y texlive-xetex
# RUN pip install Markdown==2.6.7
# RUN pip install mkdocs-pandoc
#ENTRYPOINT ["mkdocs2pandoc > mydocs.pd"]

WORKDIR /content
ENTRYPOINT ["mkdocs"]

#docker build --tag proactis/mkdocs:1 .
#docker run -it -v //C/proactis-documentation/documentation-source:/content  -p 8001:8000 proactis/mkdocs:1 serve -a 0.0.0.0:8000
#docker run -it -v //C/proactis-documentation/documentation-source:/content  -p 8001:8000 proactis/mkdocs:1 build
#docker run -it -v //C/proactis-documentation/documentation-source:/content -v //C/proactis-documentation/proactis-documentation.github.io:/proactis-documentation.github.io -p 8001:8000 proactis/mkdocs:1 build






