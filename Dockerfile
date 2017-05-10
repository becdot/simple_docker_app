FROM node:boron

# Add Tini
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app

# Copy start script
COPY start /usr/src/app/bin/
RUN chmod 0755 /usr/src/app/bin/start

EXPOSE 8080

CMD ["/tini", "-g", "--", "/usr/src/app/bin/start"]
