# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a proprietary
# license that can be found in the LICENSE file.

FROM reg.sighup.io/r/library/java/openjdk:11.0 AS builder

WORKDIR /app

COPY src src

RUN javac -d target src/Main.java

FROM reg.sighup.io/r/library/java/openjdk:11.0-jre-rootless AS runtime

WORKDIR /app

COPY --from=builder /app/target/io/sighup /app/io/sighup

ENV JAVA_MAIN_CLASS="io.sighup.Main"

EXPOSE 8080
