module Emporium
  class Product
    attr_accessor :code
    attr_accessor :service
    
    def initialize(code)
      @code = Emporium::Code.new(code)
      raise "invalid code" unless @code.valid?
    end
    
    def fetch!
      @service.response
      create @service.response
    end

    def service=(service, options={})
      klass = Emporium::Services.const_get("#{service.capitalize.to_s}")
      @service = klass.new(options.merge!(code: @code.value))
    end
    
  private
    def create(hash)
      hash.each do |key, value|
        self.instance_variable_set("@#{key.to_s}",  value)
      end
    end
    
    def method_missing(name, *args)
      if self.instance_variables.include? :"@#{name}"
        self.instance_variable_get("@#{name}")
      else
        super
      end
    end
  end
end
