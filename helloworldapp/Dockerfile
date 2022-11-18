# base image
FROM python:3.7 

# make a directory for python app
WORKDIR /app

# copy requirements into our image
COPY requirements.txt .

# install requiremetns
RUN pip install -r requirements.txt

# copy app files
COPY . .

# declare environment variable for redis
ENV ENVIRONMENT=DEV
ENV HOST=localhost
ENV PORT=8000
ENV REDIS_HOST=localhost
ENV REDIS_PORT=6379
ENV REDIS_DB=0

EXPOSE 8000

CMD ["python", "hello.py"]

