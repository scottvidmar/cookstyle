# frozen_string_literal: true
#
# Copyright:: 2020, Chef Software Inc.
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
        # The large number of shell_out helper methods in Chef Infra Client has been reduced to just shell_out and shell_out! methods. The legacy methods were removed in Chef Infra Client and cookbooks using these legacy helpers will need to be updated.
        #
        # @example
        #
        #   # bad
        #   shell_out_compact('foo')
        #   shell_out_compact!('foo')
        #   shell_out_with_timeout('foo')
        #   shell_out_with_timeout!('foo')
        #   shell_out_with_systems_locale('foo')
        #   shell_out_with_systems_locale!('foo')
        #   shell_out_compact_timeout('foo')
        #   shell_out_compact_timeout!('foo')
        #
        #   # good
        #   shell_out('foo')
        #   shell_out!('foo')
        #   shell_out!('foo', default_env: false) # replaces shell_out_with_systems_locale
        #
        class DeprecatedShelloutMethods < Cop
          extend TargetChefVersion

          minimum_target_chef_version '14.3'

          DEPRECATED_SHELLOUT_METHODS = %i( shell_out_compact
                                            shell_out_compact!
                                            shell_out_compact_timeout
                                            shell_out_compact_timeout!
                                            shell_out_with_timeout
                                            shell_out_with_timeout!
                                            shell_out_with_systems_locale
                                            shell_out_with_systems_locale!
                                          ).freeze

          MSG = 'Many legacy specialized shell_out methods were replaced in Chef Infra Client 14.3 and removed in Chef Infra Client 15. Use shell_out and any additional options if necessary.'

          def on_send(node)
            add_offense(node, location: :expression, message: MSG, severity: :warning) if DEPRECATED_SHELLOUT_METHODS.include?(node.method_name)
          end
        end
      end
    end
  end
end
