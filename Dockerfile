FROM ubuntu:latest

#ADD my_script.sh /

RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential
COPY . /app
WORKDIR /app

#RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
#ENTRYPOINT ["/bin/bash","/my_script.sh"]
#CMD ["MyFlaskApp.py","/bin/bash","/my_script.sh"]
#ENTRYPOINT ["MyFlaskApp.py"]
#CMD ["/bin/sh","/my_script.sh"]
CMD ["MyFlaskApp.py"]
