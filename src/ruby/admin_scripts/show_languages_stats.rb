#!/usr/bin/env ruby

require_relative 'lib_domain'

def gather_stats(dojo)
  puts
  renamed,rest,totals = { },{ },{ }
  exceptions = [ ]
  languages_names = dojo.languages.collect {|language| language.name}
  dot_count = 0
  dojo.katas.each do |kata|
    begin
      if !languages_names.include? kata.original_language.name
        renamed[kata.original_language.name] ||= [ ]
        renamed[kata.original_language.name] << kata.id
      else
        rest[kata.language.name] ||= [ ]
        rest[kata.language.name] << kata.id
      end
      totals[kata.language.name] ||= 0
      totals[kata.language.name] += 1
    rescue Exception => error
      exceptions << error.message
    end
    dot_count += 1
    print "\rworking" + dots(dot_count)
  end
  puts
  puts
  [renamed,rest,totals,exceptions]
end

#- - - - - - - - - - - - - - - - - - - - - - - -

def show_renamed(renamed,dojo)
  puts 'Renamed'
  puts '-------'
  count = 0
  renamed.keys.sort.each do |name|
    dots = '.' * (32 - name.length)
    print " #{name}#{dots}"
    n = renamed[name].length
    count += n
    print number(n,5)
    print "  #{renamed[name].shuffle[0]}"
    if name == dojo.languages[name].new_name
      print " --> MISSING new_name "
    else
      print " --> " + dojo.languages[name].new_name
    end
    puts
  end
  print ' ' * (33)
  print number(count,5)
  puts
  puts
end

#- - - - - - - - - - - - - - - - - - - - - - - -

def show_rest(rest,dojo)
  puts 'Rest'
  puts '----'
  count = 0
  rest.keys.sort.each do |name|
    dots = '.' * (32 - name.length)
    print " #{name}#{dots}"
    n = rest[name].length
    count += n
    print number(n,5)
    print "  #{rest[name].shuffle[0]}"
    print " --> MISSING new_name " if name != dojo.languages[name].new_name
    puts
  end
  print ' ' * (33)
  print number(count,5)
  puts
  puts
end

#- - - - - - - - - - - - - - - - - - - - - - - -

def show_totals(totals)
  puts 'Totals'
  puts '------'
  totals.sort_by{|_,v| v}.reverse.each do |name,total|
    dots = '.' * (32 - name.length)
    print " #{name}#{dots}"
    print number(total,5)
    puts
  end
  puts
  puts
end

#- - - - - - - - - - - - - - - - - - - - - - - -

dojo = create_dojo
renamed,rest,totals,exceptions = gather_stats(dojo)
show_renamed(renamed,dojo)
show_rest(rest,dojo)
show_totals(totals)
mention(exceptions)
