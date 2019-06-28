FROM debian:9
MAINTAINER Michael Senn <michael.senn@89grad.ch>

# Install dependencies for running web service
RUN apt-get update && \ 
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get -y install python-pip curl && \
    pip install werkzeug executor gunicorn

RUN cd /tmp && \
    curl -L -o wkhtml.deb https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb && \
    # Will fail due to missing dependencies, fixed in next step.
    dpkg -i wkhtml.deb; \ 
    apt-get -y install -f && \
    rm wkhtml.deb

ADD app.py /app.py
EXPOSE 80

ENTRYPOINT ["usr/local/bin/gunicorn"]

# Show the extended help
CMD ["-b", "0.0.0.0:80", "--log-file", "-", "app:application"]
