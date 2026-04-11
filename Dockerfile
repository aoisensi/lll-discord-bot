FROM dart:3 AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get --offline
RUN dart build cli --target bin/lll_discord_bot.dart -o output

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/output/bundle/ /app/

CMD ["/app/bin/lll_discord_bot"]
