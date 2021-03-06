# frozen_string_literal: true
#
# Copyright:: 2019, Chef Software Inc.
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
      module ChefEffortless
        # Cookbook:: Chef Vault does not work with Effortless
        #
        # @example
        #
        #   # bad
        #   require 'chef-vault'
        #
        #   # bad
        #   ChefVault::Item
        #
        #   # bad
        #   include_recipe 'chef-vault'
        #
        #   # bad
        #   chef_gem 'chef-vault'
        #
        #   # bad
        #   chef_vault_item_for_environment(arg, arg1)
        #
        #   # bad
        #   chef_vault_item(arg, arg1)
        #
        class ChefVaultUsed < Base
          MSG = 'Chef Vault usage is not supported in the Effortless pattern'

          def_node_matcher :require?, <<-PATTERN
            (send nil? :require
              (str "chef-vault"))
          PATTERN

          def_node_matcher :include?, <<-PATTERN
            (send nil? :include_recipe
              (str "chef-vault"))
          PATTERN

          def_node_matcher :chef_gem?, <<-PATTERN
            (send nil? :chef_gem
              (str "chef-vault"))
          PATTERN

          def_node_matcher :vault_const?, <<-PATTERN
            (const
              (const nil? :ChefVault)
              :Item)
          PATTERN

          def_node_matcher :chef_vault_item_for_environment?, <<-PATTERN
            (send nil? :chef_vault_item_for_environment _ _)
          PATTERN

          def_node_matcher :chef_vault_item?, <<-PATTERN
            (send nil? :chef_vault_item _ _)
          PATTERN

          def on_send(node)
            return unless require?(node) ||
                          chef_gem?(node) ||
                          chef_vault_item_for_environment?(node) ||
                          chef_vault_item?(node) ||
                          include?(node)
            add_offense(node.loc.expression, message: MSG, severity: :refactor)
          end

          def on_const(node)
            vault_const?(node) do
              add_offense(node.loc.expression, message: MSG, severity: :refactor)
            end
          end
        end
      end
    end
  end
end
