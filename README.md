# Gir

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gir'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gir

## Usage

### setup
`$(girc install) && source ~/.bashrc`

### add user
`girc add username`

### register public_key for github
`cd ~/.gir/uesr/username && cat ssh_key.pub | pbcopy`

### use gir
`git clone repo && cd repo && girc local username`
`echo 'blah-blah-blah' >> README`
`git commit -am 'comment'`
-> git log
Author: username <username@mail.com>

`git push -u origin master`