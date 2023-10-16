# Zirconia: A Ruby Gem Synthesiser for RSpec

Zirconia is a lightweight testing utility that is capable of generating\ temporary Ruby Gem applications from within the test suite. 

Zirconia offers an intuitive interface around the synthetic gem allowing them to be configured and coded from within the test environment.

Use cases include:
- Testing frameworks written in Ruby
- Testing autoloaders
- Testing gem-gem interaction
- Testing metaprogramming-heavy modules and classes

Currently, only `RSpec` is supported.


## Quick Start

- Add `zirconia` to your Gemfile:

```ruby
source "https://rubygems.org"

gem "zirconia"
```

- Require `zirconia/rspec` in your spec_helper:
```ruby
require "zirconia/rspec"
```

- Instantiate a Zirconia Gem in your spec using the `with_gem: gem_name` metadata:
```rspec
require 'spec_helper'

RSpec.describe "Some Gem", with_gem: :some_gem do
  it "instantiates a Zirconia Gem" do
    expect(gem).to be_a(Zirconia::Application)
  end
end
```

That's it! You can now interact with your newly spun up gem (through `gem`) in `before`/`after` hooks or in the tests themselves.

Note that calling `:with_gem` without a name argument is valid as well. In this case the gem name will be set to the default (`SomeGem`).


## Overview

Interaction, configuration and coding of your fake gem is executed through the `gem` variable set by Zirconia when the `with_gem` RSpec metadata is specified.

Gems are created using the `bundle gem` command within your system's temp directory. As gem creation is delegated to `bundler`, your local system `bundler` configuration will be respected. Gems are removed and Gem modules unsourced around each test.

Adding code to the fake gem is achieved by writing files to their respective path before loading the gem into memory. The `gem` object (an instance of `Zirconia::Application`) defines several instance methods that return `Pathname` objects at canonical locations in the gem filetree. Conventionally these are:

```
|-+temp_dir/            gem.dir
  |-+ some_gem/         gem.gem_path
    |-+ lib/            gem.lib_path
      |-- some_gem.rb   gem.main_file
      |-+ some_gem/     gem.path
        |-- foobar.rb   gem.path("foobar")
```

### Path Methods

These path methods are return a `Pathname` objects. `Pathname` is a Ruby standard library, and offers a simple interface for paths in a filetree. Of importance may be:
- `write(string)`: Writes `string` to the file at path
- `read`: Reads the contents of the file at path
- `exist?`: Returns whether a file 
- `mkdir`: Make (non recursive) a directory at the current path

The `_path` methods can be called with a variable amount of string path fragments and an optional extension. String fragments will be joined into the path, whilst the extension will be appended to the path


### Methods

#### dir
- The (temporary) directory that contains the gem

#### gem_path
- Returns `Pathname` objects for paths in the root gem directory
- In a conventional Ruby gem filetree this is `some_gem/*.ext`

#### lib_path
- Returns `Pathname` objects for paths in the gem lib directory
- In a conventional Ruby gem filetree this is `some_gem/lib/*.ext`

#### path
- Returns `Pathname` objects for paths in the gem named lib directory
- In a conventional Ruby gem filetree this is `some_gem/lib/some_gem/*.ext`

#### main_file
- Returns a `Pathname` object
- This is the entrypoint to the gem application:
- In a conventional Ruby gem filetree this is `some_gem/lib/some_gem.rb`

#### load!
- This method requires the fake gem into your current Ruby scope.
- Note that this process is not idempotent as gems will not be reloaded.


## Example

Say we are creating a fancy new testing framework `spectacular`, and we want to test how it behaves when included in target Ruby gem applications. `spectacular` defines an `Initialiser` class that is run when the gem is included into its target gem.

With `zirconia`, we can spin up a target Gem, write some Ruby code to be injected into the Gem entrypoint, and then test how it behaves when run. This could look something like:

```ruby
RSpec.describe Spectacular::Initialiser, :with_gem do
  before do
    gem.main_file.write(<<~RUBY)
      require "spectacular"

      module SomeGem
        extend Spectacular::Initialiser
      end
    RUBY
  end

  describe "requiring Spectacular" do
    subject(:require_spectacular) { gem.load! }

    it "loads the gem" do
      expect { require_spectacular }
        .to change { Object.const_defined?(:SomeGem) }
        .from(false)
        .to(true)
    end
  end
end
```
