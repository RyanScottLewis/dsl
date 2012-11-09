class CharacterWithStatsAndAttrReader
  
  class Stats
    attr_writer :name, :age
    
    def name
      @name.split(/\s+/).first.upcase
    end
    
    def age
      @age.to_i
    end
  end
  
  class AttrDSL < DSL
    def_dsl_delegator :@stats, :name, :age
  end
  
  def initialize(&blk)
    @stats = Stats.new
    @dsl = AttrDSL.call(stats: @stats, &blk)
  end
  
end
