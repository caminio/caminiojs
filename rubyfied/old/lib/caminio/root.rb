module Caminio

  def self.root
    File::join( Dir.pwd, opts )
  end

  module Root

    def self.join( *opts )
      File::join( Dir.pwd, opts )
    end

  end

end
