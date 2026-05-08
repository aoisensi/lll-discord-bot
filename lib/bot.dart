import 'dart:async';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:nyxx/nyxx.dart';

class Bot {
  static final _token = Platform.environment['DISCORD_TOKEN']!;
  static final _channel = Snowflake.parse(
    Platform.environment['DISCORD_CHANNEL']!,
  );

  final NyxxGateway gateway;
  final Cron cron = Cron();

  late final channel = PartialTextChannel(
    id: _channel,
    manager: gateway.channels,
  );

  Bot(this.gateway);

  static Future<Bot> setup() async {
    final gateway = await Nyxx.connectGateway(
      _token,
      GatewayIntents.allUnprivileged,
    );
    return Bot(gateway);
  }

  Future<void> run() async {
    print('running!');
    cron.schedule(Schedule.parse('0 0 * * *'), dailyCron);
    print('Ctrl+C to close...');
    await Future.any([
      ProcessSignal.sigint.watch().first,
      ProcessSignal.sigterm.watch().first,
    ]);
    await close();
  }

  Future<void> close() async {
    await Future.wait([cron.close(), gateway.close()]);
  }

  Future<void> dailyCron() async {
    print('daily cron');
    final now = DateTime.now();
    var year = now.year;
    var aug = DateTime(year, 8, 1);
    if (now.isBefore(aug)) {
      aug = DateTime(year - 1, 8, 1);
      year -= 1;
    }
    final hachigatsu = () {
      final day = now.difference(aug).inDays + 1;
      if (day == 111) return 'lll';
      return day.toString();
    }();
    final greeting = switch (hachigatsu) {
      '1' => 'あけましておめでとうございます。',
      _ => 'おはようございます。',
    };
    await channel.sendMessage(
      MessageBuilder(content: '$greeting今日は$year年8月$hachigatsu日です。'),
    );
  }
}
