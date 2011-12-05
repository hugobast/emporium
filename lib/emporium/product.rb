module Emporium
  class Product
    attr_accessor :code
    attr_accessor :service
    
    def initialize(code)
      @code = Emporium::Code.new(code)
      raise "invalid code" unless @code.valid?
    end
    
    def fetch!
      create @service.response
    end

    def use(service)
      @service = service.new(code: @code.value)
    end

    def method_missing(name, *args)
      if self.instance_variables.include? :"@#{name}"
        self.instance_variable_get("@#{name}")
      else
        super
      end
    end
    
  private
    def create(response)
      response.search("ItemAttributes").children.each do |value|
        self.instance_variable_set("@#{value.name.downcase}",  value.content)
      end
    end
  end
end
