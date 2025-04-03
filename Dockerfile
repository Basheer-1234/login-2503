# - Means Comment, docker will ignore this

# FROM is used to set BASE functionality
# FROM ubuntu:22 --> Repeat all the process of setting up nginx again

FROM nginx

# COPY is used to copy files from host to above custom image
COPY . /usr/share/nginx/html
