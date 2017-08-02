FROM openshift/base-centos7
MAINTAINER Oliver Weise <oliver.weise@consol.de>
LABEL io.k8s.description="Builder image for Maven-built JavaScript Apps (AngularJS for example) also using NPM in the build process, published via nginx" \
      io.k8s.display.name="s2i Maven && npm builder to nginx" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nginx,js"
RUN yum install -y epel-release
RUN yum install -y yum-utils && \
    yum makecache fast && \
    yum install -y maven && \
    yum install -y nginx
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
    yum -y install nodejs
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
ENV NODE_ENV=development
COPY ./s2i/bin/ /usr/local/s2i
COPY ./nginx.conf /etc/nginx/nginx.conf
RUN chmod -R a+rwx /opt/app-root
RUN chmod -R a+rwx /var/log
RUN chmod -R a+rwx /var/lib/nginx
RUN chmod -R a+rwx /run
USER 1001
EXPOSE 8080
CMD ["usage"]