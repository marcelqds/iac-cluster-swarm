FROM alpine
RUN apk add --no-cache zip unzip curl bash && curl -s "https://get.sdkman.io" | bash && chmod 744 "/root/.sdkman/bin/sdkman-init.sh" && "/root/.sdkman/bin/sdkman-init.sh"

