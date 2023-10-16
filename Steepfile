target :lib do
  signature "sig"

  check "lib"

  # Too much RSpec interfacing to type.
  ignore "lib/zirconia/rspec.rb"

  configure_code_diagnostics do |hash|
    hash[Steep::Diagnostic::Ruby::FallbackAny] = nil
    hash[Steep::Diagnostic::Ruby::UnknownConstant] = :error
    hash[Steep::Diagnostic::Ruby::MethodDefinitionMissing] = nil
    hash[Steep::Diagnostic::Ruby::UnsupportedSyntax] = :hint
  end
end
