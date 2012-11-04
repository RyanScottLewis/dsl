class CharacterWithoutAttributes
  
  class AttrDSL < DSL
    def_dsl_delegator :name, :age
  end
  
  def initialize(&blk)
    AttrDSL.call(self, &blk)
  end
  
end
