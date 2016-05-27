module ComponentsManagement

  class Component
      
    attr_accessor :name, :parents, :children
    @@component_instances_list = []

    def initialize(name)
      @name = name
      @parents = []
      @children = []
      @@component_instances_list << self
    end

    def add_child(c)
      if @children.any?
        @children << c unless @children.include? c
      else
      	@children = [c]
      end
    end

    def remove_child(c)
  	  @children.delete(c) if @children
    end

    def add_parent(p)
      if @parents.any?
        @parents << p unless @parents.include? p
      else
      	@parents = [p]
      end
    end

    def remove_parent(p)
  	  @parents.delete(p) if @parent
    end

    def self.find_by(name)
      @@component_instances_list.each do |comp|
        if comp.name == name
        	return comp
        end
      end
      return nil
    end

    def self.display_array(arr)
      result = ""
      arr.each do |a|
        result << " " << a
      end
      puts result
    end

    def self.show
    	@@component_instances_list.each do |comp|
    	  puts "\nNAME: #{comp.name}"
    	  puts "PARENTS: #{comp.parents}"
    	  puts "CHILDREN: #{comp.children}"
      end
      puts "total number of components: #{@@component_instances_list.size}"
    end
  end

  $LIST = []
  sample_input = []
  File.open('sample_input.txt').each do |line|
    words = line.split(" ")
    sample_input  << words
  end

  sample_input.each do |command|
    case command[0]
    when 'DEPEND'
      Component.display_array(command)
      for index in 1...command.size
        comp = Component.find_by(command[index])
        comp = Component.new(command[index]) unless comp
        for parent_index in (index+1)...command.size
          if command[parent_index]
            comp.add_parent((command[parent_index]))
            parent_comp = Component.find_by(command[parent_index])
            parent_comp = Component.new(command[parent_index]) unless parent_comp
          end
        end
        for child_index in (index-1).downto(1)
          if command[child_index]
            comp.add_child(command[child_index])
          end
        end
      end
    when 'INSTALL'
      Component.display_array(command)
      unless $LIST.include? command[1]
        comp = Component.find_by(command[1])
        if comp
          comp.parents.each do |parent|
            unless $LIST.include? parent
              puts "\tInstalling #{parent}"
              $LIST << parent
            end
          end
        else
          comp = Component.new(command[1]) unless comp
        end
        puts "\tInstalling #{comp.name}"
        $LIST << comp.name
      else
        puts "\t#{command[1]} is already installed"
      end
      when 'REMOVE'
        Component.display_array(command)
        if $LIST.include? command[1]
          comp = Component.find_by(command[1])
          if comp
            flag = false
            comp.children.each do |child|
              if $LIST.include? child
                puts "\t#{command[1]} is still needed."
                flag = true;
                break
              end
            end
            unless flag
              puts "\tRemoving #{comp.name}"
              $LIST.delete(comp.name)
              comp.parents.each do |parent|
                parent_instance = Component.find_by(parent)
                flag1 = false
                parent_instance.children.each do |child|
                  if $LIST.include? child
                    flag1 = true
                    break
                  end
                end
                unless flag1 do
                  puts "\tRemoving #{parent}"
                  $LIST.delete(parent)
                end
              end

              end
            end

          else
            comp = Component.new(command[1]) unless comp
          end
        else
          puts "\t#{command[1]} is not installed"
        end
      when 'LIST'
        Component.display_array(command)
        $LIST.each do |l|
          puts "\t#{l}"
        end

    end
  end
end