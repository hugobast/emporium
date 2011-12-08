module Emporium
  module Services

    module Options
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def configuration
          yield self
          self
        end

        def service_attr_accessor(*symbols)
          symbols.each do |symbol|
            class_eval(<<-EOS)
              def self.#{symbol}
                @@#{symbol}
              end

              def self.#{symbol}=(value)
                @@#{symbol} = value
              end
            EOS
          end
        end
      end
    end
  
  end
end