# Emporium

Automatic identification and data capture library to read UPC/EAN and get as much information as it possibly can.

## Installation

Add to your Gemfile and run the `bundle` command to install it.

 ```ruby
 gem "emporium"
 ```

**Requires Ruby 1.9.2 or later.**

## Configuration

 ```ruby
 service = Emporium::Services::Amazon.configuration do |config|
   config.access_key = "access_key"
   config.associate_tag = "associate_tag"
   config.secret = "secret"
 end
 ```


## Usage

Give it a UPC to fetch a product object. The Code only takes UPC-A digits

 ```ruby
 require 'emporium'

 product = Emporium::Product.new("066661234567")
 product.use service
 product.fetch!
 ```



## Development

This gem is under the MIT License.