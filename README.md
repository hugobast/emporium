# Emporium

Automatic identification and data capture library to read UPC/EAN and get as much information as it possibly can.

## Installation

Add to your Gemfile and run the `bundle` command to install it.

 ```ruby
 gem "emporium"
 ```

**Requires Ruby 1.9.2 or later.**


## Usage

Given a UPC returns a product object that gets populated calling fetch. The Code class takes UPC-A or EAN digits

 ```ruby
 require 'emporium'

 product = Emporium::Product.new "066661234567"
 product.fetch!
 ```

## Development

This gem is created by Hugo Bastien and is under the MIT License.