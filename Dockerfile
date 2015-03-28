FROM node:onbuild

RUN npm install -g coffee-react

RUN wget -O wkhtml.deb http://downloads.sourceforge.net/project/wkhtmltopdf/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb \
    && apt-get update && apt-get install -y xfonts-base xfonts-75dpi  \
    && dpkg -i wkhtml.deb && apt-get install -f
