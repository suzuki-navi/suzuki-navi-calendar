# frozen_string_literal: true

require_relative "calendar/version"

module Suzuki
  module Navi
    module Calendar
      def main
        puts("Hello")
        p ARGV
      end
      module_function :main
    end
  end
end
