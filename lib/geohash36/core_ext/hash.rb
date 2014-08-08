#!/usr/bin/env ruby


# @class        class Hash
# @brief
class Hash

  # @fn         def except *keys {{{
  # @brief      Deletes specified keys from hash copy and returns it
  # @credit     https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/hash/except.rb
  def except(*keys)
    copy = self.dup
    keys.each { |key| copy.delete(key) }
    copy
  end #}}}

end
