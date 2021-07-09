FROM julia

ENV DEBIAN_FRONTEND noninteractive
RUN apt update; apt -y dist-upgrade
RUN apt install -y gtk+3.0

WORKDIR /app

COPY installgtk.jl .

RUN julia installgtk.jl

COPY . .

CMD [ "julia", "main.jl" ]