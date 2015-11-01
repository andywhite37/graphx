import utest.Runner;
import utest.ui.Report;

class TestAll {
  static function addCases(runner : Runner) {
    runner.addCase(new graphx.TestGraph());
  }

  public static function main() {
    var runner = new Runner();
    addCases(runner);
    Report.create(runner);
    runner.run();
  }
}
