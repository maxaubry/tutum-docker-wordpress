FROM tutum/lamp:latest
MAINTAINER Fernando Mayo <fernando@tutum.co>, Feng Honglin <hfeng@tutum.co>

# Download latest version of Wordpress into /app
RUN rm -fr /app && git clone --depth=1 https://github.com/WordPress/WordPress.git /app

# Configure Wordpress to connect to local DB
ADD wp-config.php /app/wp-config.php

# Modify permissions to allow plugin upload
RUN chown -R www-data:www-data /app/wp-content /var/www/html

# Add database setup script
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD create_db.sh /create_db.sh
RUN chmod +x /*.sh

RUN apt-get update
RUN apt-get install -y cloud-init openssh-server
RUN mkdir -p /var/run/sshd


RUN useradd -m -d /home/hexanet -s /bin/bash hexanet
RUN mkdir -p /home/hexanet/.ssh
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc/HDOYzIXzH7m30dJhfl6d391Qh8430MDebv6x/ZU0iGmOqYosIrajVvG4Ou3LfCRxlu7JlNnpJMOnH4QRonCemF2QT587fcJA5nzzYSWbA6gKjM2TwamMojXj3C5b+m9MhqgX3P9hFTJtAA+SoywMEKUokNqU5msDh5VNCFJB2Nly7SVcg3gHtehaXWbKcqZGP9omRb2TTUYdRIC8jn1reKvykEvu0w0IxMjnn3CZOZ0De/e9/OM6uV4TWL+tCZTckH+HLq+1+CoLs3OnRnKMkkjLZTez4+/LIEd0njm7mbWFyHyIo6ZdgUTTM/vU1ls39CQTJZJ7id4zpeInziR max@debian" >> /home/hexanet/.ssh/authorized_keys
EXPOSE 22
CMD /usr/sbin/sshd -D
RUN echo "root:root" | chpasswd


EXPOSE 80 3306

CMD ["/run.sh"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
