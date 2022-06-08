VERSION 0.6
FROM ubuntu:22.04

base-image:
  RUN apt update && apt -y install curl git zip

terraform:
  FROM +base-image
  RUN curl -Lo ./terraform.zip https://releases.hashicorp.com/terraform/1.2.0/terraform_1.2.0_linux_amd64.zip && \
      unzip ./terraform.zip -d /usr/bin/
  RUN terraform --version

tfsec:
  FROM +terraform
  RUN curl -Lo ./tfsec https://github.com/aquasecurity/tfsec/releases/download/v1.16.3/tfsec-linux-amd64 && \
      chmod +x ./tfsec && mv ./tfsec /usr/bin/tfsec
  RUN tfsec -v

init:
  FROM +tfsec
  WORKDIR /project
  COPY --dir ./modules .

tf-check:
  FROM +init
  ARG src
  RUN cd $src && \
      terraform init && \
      terraform validate && \
      tfsec

build-modules:
  FROM +init
  FOR dir IN $(ls -d ./modules/*)
    BUILD +tf-check --src="$dir"
  END
  SAVE IMAGE piab-modules:latest

deploy-example:
  BUILD ./example/realworld+deploy