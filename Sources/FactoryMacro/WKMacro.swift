import Factory

@attached(extension, conformances: SharedContainer)
@attached(member, names: named(shared), named(manager))
public macro FactoryContainer() = #externalMacro(module: "FactoryMacroMacros", type: "FactoryContainer")
