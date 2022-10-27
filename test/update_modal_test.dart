import 'package:flutter_test/flutter_test.dart';
import 'package:update_modal/src/utils.dart';

Future sleep(int ms) => Future.delayed(Duration(milliseconds: ms));

void main() {
  test('withThrottle', () async {
    var flag = 0;
    final addFlag = withThrottle(
      () => flag++,
      const Duration(milliseconds: 50),
    );
    addFlag(); // 1
    expect(flag, 1);
    addFlag(); // 1
    addFlag(); // 1
    addFlag(); // 1
    addFlag(); // 1
    addFlag(); // 1
    expect(flag, 1);
    await sleep(50);
    addFlag(); // 2
    expect(flag, 2);
    await sleep(50);
    addFlag(); // 3
    expect(flag, 3);
    await sleep(40);
    addFlag(); // 3
    expect(flag, 3);
  });
}
