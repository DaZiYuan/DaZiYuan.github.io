# node 环境镜像
FROM node:latest AS build-env
# 创建 hexo-blog 文件夹且设置成工作文件夹
RUN mkdir -p /usr/src/hexo-blog
WORKDIR /usr/src/hexo-blog
# 复制当前文件夹下面的所有文件到 hexo-blog 中
COPY . .
# 安装 hexo-cli
RUN npm --registry=https://registry.npm.taobao.org install hexo-cli -g && npm install
# 生成静态文件
RUN hexo clean && hexo g

# 配置 nginx
FROM nginx:latest
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /usr/share/nginx/html
# 把上一部生成的 HTML 文件复制到 Nginx 中
COPY --from=build-env /usr/src/hexo-blog/public /usr/share/nginx/html
EXPOSE 8002