class CharacterWithAttrWriter
  
  class AttrDSL < DSL
    def_dsl_delegator :name, :age
  end
  
  def initialize(&blk)
    @dsl = AttrDSL.call(self, &blk)
  end
  
  def name=(value)
    @name = value.split(/\s+/).first.upcase
  end
  
  def age=(value)
    @age = value.to_i
  end
  
end
