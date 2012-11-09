unless String.method_defined?(:underscore)
  class String
    def underscore
      word = dup
      word.gsub!(%r{::}, '/')
      # word.gsub!(%r{(?:([A-Za-z\d])|^)(#{inflections.acronym_regex})(?=\b|[^a-z])}) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
      word.gsub!(%r{([A-Z\d]+)([A-Z][a-z])},'\1_\2')
      word.gsub!(%r{([a-z\d])([A-Z])},'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
