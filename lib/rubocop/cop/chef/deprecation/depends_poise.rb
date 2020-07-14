# frozen_string_literal: true
#
# Copyright:: 2019, Chef Software, Inc.
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module RuboCop
  module Cop
    module Chef
      module ChefDeprecations
        # Cookbooks should not depend on the deprecated Poise framework cookbooks. They should instead be refactored to use standard Chef Infra custom resources.
        #
        # @example
        #
        #   # bad
        #   depends 'poise'
        #   depends 'poise-service'
        #
        class CookbookDependsOnPoise < Cop
          MSG = 'Cookbooks should not depend on the deprecated Poise framework'

          def_node_matcher :depends_method?, <<-PATTERN
            (send nil? :depends $str)
          PATTERN

          def on_send(node)
            depends_method?(node) do |arg|
              add_offense(node, location: :expression, message: MSG, severity: :warning) if %w(poise poise-service).include?(arg.value)
            end
          end
        end
      end
    end
  end
end
