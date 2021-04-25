$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "byebug"
require "fileutils"
require "minitest/autorun"
require "minitest/spec"
require "minitest/given"
require "minitest/pride"
require "mocha/minitest"
require "roro"
require "helpers/rails"
require "helpers/matchers/files"
require "helpers/matchers/insertions"
require "helpers/mocks"
require "helpers/thor"

include TestHelper::Files::Assertions
include TestHelper::Stories::Rails
include TestHelper::Mocks::Stubs
include TestHelper::Mocks::Stubs
include TestHelper::Matchers::Insertions
include TestHelper::Matchers::Files

