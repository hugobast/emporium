# Emporium

Automatic identification and data capture library to read UPC/EAN and get as much information as it possibly can.


## Installation

Add to your Gemfile and run the `bundle` command to install it.

 ```ruby
 gem "emporium"
 ```

**Requires Ruby 1.9.2 or later.**


## Configuration

#### Amazon

 ```ruby
 Emporium::Services::Amazon.configuration do |config|
   config.access_key = "access_key"
   config.associate_tag = "associate_tag"
   config.secret = "secret"
 end
 ```

#### Google

 ```ruby
 Emporium::Services::Google.configuration do |config|
   config.access_key = "access_key"
   config.cme = "cse" # custom search engine
 end
 ```


## Usage

Give it a UPC to fetch a product object. The Code only takes UPC-A digits

 ```ruby
 require 'emporium'

 product = Emporium::Product.new("066661234567")
 product.use :google # or :amazon
 product.fetch!
 ```


## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/hugobast/emporium/issues). 

You can contribute changes by forking the project and submitting a pull request. You can ensure the tests passing by running `bundle` and `rake`. Create a yml file under the spec folder that looks like this first:

```yaml
amazon:
  secret: <secret>
  access_key: <access_key>
  associate_tag: <associate_tag>

google:
  access_key: <access_key>
  cse: <custom_search_engine>
```

## Licence

Copyright (c) 2011 Hugo Bastien

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.