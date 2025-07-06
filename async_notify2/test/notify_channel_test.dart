import 'package:async_notify2/async_notify2.dart';
import 'package:test/test.dart';

Future main() async {
  test('NotifyChannel.receive()', () async {
    final channel = NotifyChannel<int>(Notify());

    channel.send(0);
    channel.send(1);

    expect(channel.isNotEmpty, isTrue);
    expect(await channel.receive(), equals(0));
    expect(await channel.receive(), equals(1));
    expect(channel.isEmpty, isTrue);
  });
}
