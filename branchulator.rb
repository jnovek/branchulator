#!/usr/bin/ruby
class String

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def yellow
    "\e[33m#{self}\e[0m"
  end

end

def needs_commit?
  `git status 2>&1` !~ /nothing to commit/
end

def merge_conflict?
  `git status 2>&1` =~ /conflict/
end

unless `git rev-parse --git-dir 2>&1` =~ /fatal/i
  text = " git:" + `git rev-parse --abbrev-ref HEAD 2>&1`.chomp + " "
  if merge_conflict?
    print text.red
  elsif needs_commit?
    print text.yellow
  else
    print text.green
  end
end
