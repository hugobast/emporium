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

        def service_attr_accessor(*attributes)
          attributes.each do |attribute|
            class_eval(<<-EOS)
              def self.#{attribute}
                @@#{attribute}
              end

              def self.#{attribute}=(value)
                @@#{attribute} = value
              end
            EOS
          end
        end
      end
    end
  
  end
end