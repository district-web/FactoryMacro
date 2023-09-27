import Factory
import FactoryMacro

struct TestService {}

@FactoryContainer()
final class MyContainer {
    var test: Factory<TestService> {
        self {
            TestService()
        }
    }
}
