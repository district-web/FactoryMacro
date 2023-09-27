import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(FactoryMacroMacros)
    import FactoryMacroMacros

    let testMacros: [String: Macro.Type] = [
        "FactoryContainer": FactoryContainer.self,
    ]
#endif

final class FactoryMacroTests: XCTestCase {
    func testMacroFactoryContainer() throws {
        #if canImport(FactoryMacroMacros)
            assertMacroExpansion(
                """
                @FactoryContainer()
                class Test {}
                """,
                expandedSource: """
                class Test {

                    static let shared = Test()

                    let manager = ContainerManager()}

                extension Test: SharedContainer {
                }
                """,
                macros: testMacros
            )
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testURLStringLiteralError() {
        #if canImport(FactoryMacroMacros)
            assertMacroExpansion(
                #"""
                @FactoryContainer()
                struct Test {}
                """#,
                expandedSource: #"""
                struct Test {}
                """#,
                diagnostics: [
                    DiagnosticSpec(message: "@FactoryContainer() can be only applied to class", line: 1, column: 1),
                    DiagnosticSpec(message: "@FactoryContainer() can be only applied to class", line: 1, column: 1),
                ],
                macros: testMacros
            )
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
