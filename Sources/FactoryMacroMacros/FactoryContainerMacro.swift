import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum FactoryContainerMacroError: Error, CustomStringConvertible {
    case requireClass

    var description: String {
        switch self {
        case .requireClass:
            "@FactoryContainer() can be only applied to class"
        }
    }
}

public struct FactoryContainer: MemberMacro, ExtensionMacro {
    public static func expansion(
        of _: SwiftSyntax.AttributeSyntax,
        attachedTo: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo _: [SwiftSyntax.TypeSyntax],
        in _: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard attachedTo is ClassDeclSyntax else { throw FactoryContainerMacroError.requireClass }

        let containerExtension: DeclSyntax =
            """
            extension \(type.trimmed): SharedContainer {}
            """

        guard let extensionDecl = containerExtension.as(ExtensionDeclSyntax.self) else {
            return []
        }

        return [extensionDecl]
    }

    public static func expansion(
        of _: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in _: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let classDeclaration = declaration as? ClassDeclSyntax else { throw FactoryContainerMacroError.requireClass }

        let identifier = classDeclaration.name.trimmed

        let initManagerSyntax =
            FunctionCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: "ContainerManager()")) {}
        let initManager = InitializerClauseSyntax(equal: .equalToken(trailingTrivia: .space), value: initManagerSyntax)
        let manager = VariableDeclSyntax(.let, name: "manager", initializer: initManager)

        let staticToken = DeclModifierSyntax(name: "static")
        let staticModifier = DeclModifierListSyntax([staticToken])

        let initSharedSyntax = FunctionCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: "\(identifier)()")) {}
        let initShared = InitializerClauseSyntax(equal: .equalToken(trailingTrivia: .space), value: initSharedSyntax)
        let shared = VariableDeclSyntax(modifiers: staticModifier, .let, name: "shared", initializer: initShared)

        return [
            DeclSyntax(shared),
            DeclSyntax(manager),
        ]
    }
}

@main struct FactoryMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FactoryContainer.self,
    ]
}
