require 'neology/index_mixin/class_methods'
require 'neology/index_mixin/query_builder'

module Neology

  module IndexMixin

    def self.included(base)

      base.extend(Neology::IndexMixin::ClassMethods)

    end

  end

end