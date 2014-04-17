module Puppet::Parser::Functions
  newfunction(:subdir_list_from_str, :type => :rvalue, :doc => "Takes two strings, first a path, and second a sub directory starting at the first path, and returns an array of directory strings for each subdirectory level. Example:

subdir_list_from_str('/usr/lib','megafrobber/bin/') would return:

[ '/usr/lib/megafrobber', '/usr/lib/megafrobber/bin' ]

Use this if you're making a lot of directories, as in: http://www.puppetcookbook.com/posts/creating-a-directory-tree.html" ) do |args|
    Puppet::Parser::Functions.function(:dir_list_from_str)
    dir_list = Array.new
    # Remove trailing / from args[0]
    prefix = args[0].gsub(/\/$/, '')
    suffix = args[1].gsub(/\A\//,'')
    # Get list of subdirs
    function_dir_list_from_str( [ suffix ] ).each { |d|
      dir_list.push(prefix + "/" + d)
    }
    dir_list.delete_if{|x| x==''}
  end
end
