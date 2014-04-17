module Puppet::Parser::Functions
  newfunction(:dir_list_from_str, :type => :rvalue, :doc => "Takes a string representing a directory path and returns a list where each successive element is a string representing another deeper level of the directory. Example:

dir_list_from_str('/usr/lib/megafrobber/bin/') would return:

[ '/usr', '/usr/lib', '/usr/lib/megafrobber', '/usr/lib/megafrobber/bin' ]

Use this if you're making a lot of directories, as in: http://www.puppetcookbook.com/posts/creating-a-directory-tree.html" ) do |arg|
    dir_list = Array.new
    absolute = arg[0].start_with?('/')
    # Remove leading trailing slash from input, split on '/'
    dir_levels=arg[0].gsub(/\/\Z/,'').gsub(/\A\//,'').split('/')
    dir_levels.each { |d|
      if dir_list.length == 0
        if absolute then
          dir_list.push "/"+d
        else
          dir_list.push d
        end
      else
        dir_list.push dir_list[-1]+"/"+d
      end
    }
    dir_list.delete_if{|x| x==''}
  end
end
