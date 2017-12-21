module DowncaseNames
  module ClassMethods
    def downcase_names
      self.all.collect do |instance|
        instance.name.downcase
      end
    end
  end
end
