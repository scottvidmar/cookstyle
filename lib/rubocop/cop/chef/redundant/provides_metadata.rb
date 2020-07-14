# frozen_string_literal: true
#
# Copyright:: 2019, Chef Software Inc.
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
      module ChefRedundantCode
        # The provides metadata.rb method is not used and is unnecessary in cookbooks.
        #
        # @example
        #
        #   # bad in metadata.rb:
        #
        #   provides "some_thing"
        #
        class ProvidesMetadata < Cop
          include RangeHelp

          MSG = 'The provides metadata.rb method is not used and is unnecessary in cookbooks.'

          def on_send(node)
            add_offense(node, location: :expression, message: MSG, severity: :refactor) if node.method_name == :provides
          end

          def autocorrect(node)
            lambda do |corrector|
              corrector.remove(range_with_surrounding_space(range: node.loc.expression, side: :left))
            end
          end
        end
      end
    end
  end
end
