import 'dart:io';

import 'package:lll_discord_bot/bot.dart';

Future<void> main(List<String> arguments) async {
  await (await Bot.setup()).run();
  exit(0);
}
