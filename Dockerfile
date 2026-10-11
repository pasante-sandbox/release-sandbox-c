# A static page that shows which commit and environment it was deployed as.
FROM nginx:1.27.3-alpine

ARG COMMIT=unknown
ARG ENVIRONMENT=local

COPY index.html /usr/share/nginx/html/index.html
RUN sed -i "s/__COMMIT__/${COMMIT}/; s/__ENVIRONMENT__/${ENVIRONMENT}/" /usr/share/nginx/html/index.html
