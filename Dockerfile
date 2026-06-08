FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl hwinfo sudo pciutils iptables

# Já deixa o PATH pronto para quando VOCÊ instalar o Golem
ENV PATH="/root/.local/bin:${PATH}"

CMD ["golemsp", "run"]
