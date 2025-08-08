FROM bash AS build

# copy apaxy and proceed to configuration
WORKDIR /
# Copy the Apaxy repo from the git submodule
ADD Apaxy /Apaxy
RUN cd /Apaxy && bash apaxy-configure.sh -w "APAXY_TEMP_FOLDER" -d "/var/www/html"

FROM httpd:2.4-alpine

RUN echo "Include conf/sites-enabled/*.conf" >> \
    /usr/local/apache2/conf/httpd.conf

#
# Copy the Apaxy repo from the build stage
#
COPY --from=build /Apaxy /root/Apaxy
COPY --from=build /var/www/htmlAPAXY_TEMP_FOLDER /root/Apaxy/webroot

VOLUME /data
EXPOSE 80

#
# Copy the local files
#
ADD ./run.sh /root/run.sh
ADD ./tpl/apaxy.tpl /root/apaxy.tpl
RUN chmod 755 /root/run.sh

CMD ["/root/run.sh"]
