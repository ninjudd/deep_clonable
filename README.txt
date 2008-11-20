= DeepClonable

DeepClonable is an extension that add deep clone support to any Class. Just call
deep_clonable in the class definition. You can also define special behavior when cloning
by overriding the clone_fields method. By default, all Arrays and Hashes will be deep
cloned.

== INSTALL:

  sudo gem install deep_clonable

== USAGE:

class Foo
  deep_clonable

  attr_reader :array

  def initialize(array)
    @array = array
  end

  def clone_fields
    # Only deep clone a single variable, all other variables will be just be copied directly.
    @array = @array.clone
  end
end

foo = Foo.new([1,2,3])
bar = Foo.clone

foo.array
# => [1,2,3]

bar.array
# => [1,2,3]

bar.array << 4
bar.array
# => [1,2,3,4]

foo.array
# => [1,2,3]

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
