#!/usr/bin/ruby

RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"

def needs_commit?
  `git status 2>&1` !~ /nothing to commit/
end

def merge_conflict?
  `git status 2>&1` =~ /conflict/
end

def origin_status(branch)
  ""
end

# Program body
# Don't do this if we're not in a working repo
unless `git rev-parse --git-dir 2>&1` =~ /fatal/i

  branch = `git rev-parse --abbrev-ref HEAD 2>&1`.chomp

  if ARGV[0] == 'color'
    # For coloring
    if merge_conflict?
      print RED
    elsif needs_commit?
      print YELLOW
    else
      print GREEN
    end  
  elsif ARGV[0] == 'decolor'
    # For decoloring
    print "\e[0m"
  else
    # output the actual git repo
    print "git:" + branch + origin_status(branch) + " "
  end

end
