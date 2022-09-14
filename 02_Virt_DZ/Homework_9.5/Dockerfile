FROM centos:7

RUN yum install python3 puthon3-pip -y
RUN pip3 install flask flask-jsonpify flask-restful
RUN mkdir /python_api
COPY python-api.py /python_api/python-api.py
CMD ["python3", "/python_api/python-api.py"]
