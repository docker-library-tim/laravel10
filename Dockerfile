FROM xiaotim/php-base:php8.2


# 把阿里云镜像地址换成内网地址，不开公网就可以安装各种软件。
RUN sed -i "s/mirrors.aliyun.com/mirrors.cloud.aliyuncs.com/g" /etc/apk/repositories && sed -i "s/https/http/g" /etc/apk/repositories

WORKDIR /data

COPY ./ /data/

RUN chown www:www -R /var/lib/nginx \
    && mkdir -p /mnt/data/storage/framework/views \
    && chmod -R 777 /mnt/data \
    && chown www:www -R  /data/storage \
    && rm /etc/nginx/http.d/default.conf \
    && mv /data/nginx.conf /etc/nginx/http.d/ \
    && mv /data/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf \
    && mv /data/.env.example /data/.env \
    # && echo "TZ=Asia/Shanghai" > /etc/crontabs/root \
    && echo "* * * * * /usr/local/bin/php /data/artisan schedule:run" >> /etc/crontabs/root \
    && composer install --no-dev \
    && php /data/artisan route:cache
