class CharacterWithAttrReader
  
  class AttrDSL < DSL
    def_dsl_delegator :name, :age
  end
  
  def initialize(&blk)
    @dsl = AttrDSL.call(self, &blk)
  end
  
  def name
    @name.split(/\s+/).first.upcase
  end
  
  def age
    @age.to_i
  end
  
end
