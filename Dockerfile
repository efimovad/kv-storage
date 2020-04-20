FROM tarantool/tarantool:latest

EXPOSE $PORT

COPY . .

CMD gunicorn --bind 0.0.0.0:$PORT wsgi & tarantool ./main.lua $PORT
