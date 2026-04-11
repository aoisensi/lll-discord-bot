FROM dart:3 AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get --offline
RUN dart

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/output/bundle/ /app/

CMD ["/app/bin/server"]
