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

def origin_diff_count(branch)
  # First make sure that there's a remote branch
  return "" if `git rev-list origin/#{branch}..HEAD 2>&1` =~ /fatal/
  # Get the number of remote commits and number of local commits
  remote_changes = `git rev-list HEAD..origin/#{branch}`.chomp.split("\n").count
  local_changes = `git rev-list origin/#{branch}..HEAD`.chomp.split("\n").count
  # Finally, pick what to output based on our remote/local change count
  return "[-#{remote_changes}/+#{local_changes}]" if remote_changes > 0 && local_changes > 0
  return "[-#{remote_changes}]" if remote_changes > 0
  return "[+#{local_changes}]" if  local_changes > 0
  "[=]"
end

def fatal?
  (`git rev-parse --git-dir 2>&1` =~ /fatal/) != nil ||
  (`git rev-parse --abbrev-ref HEAD 2>&1` =~ /fatal/) != nil
end

# Program body
# Don't do this if we're not in a working repo
unless fatal?

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
    print "git:" + branch + origin_diff_count(branch) + " "
  end

end
