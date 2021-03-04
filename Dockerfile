FROM openjdk:15-jdk-alpine as builder
LABEL Shimun Matic <shimun.matic@gmail.com>
WORKDIR /workspace/app

COPY . /workspace/app
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM openjdk:15-jdk-alpine
ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=builder ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=builder ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=builder ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java", "--enable-preview","-cp", "app:app/lib/*",  "com.shimunmatic.ecommerce.gateway.ECommerceGatewayApplication"]

