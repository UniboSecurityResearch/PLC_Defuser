FROM python:3.9
COPY . /app/
RUN pip3 install -r /app/requirements.txt

RUN wget "https://github.com/formalmethods/intrepid/raw/master/libs/linux64/_api.so" -O /app/intrepyd/_api.so

WORKDIR /app/
ENV PYTHONPATH="${PYTHONPATH}:/app"
CMD ["python3", "malicious/check_requirements.py"]



