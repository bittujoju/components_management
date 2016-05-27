module ComponentsManagement

  class Component
      
    attr_accessor :name, :parents, :children
    @@component_instances_list = []

    def initialize(name)
      @name = name
      @parents = []
      @children = []
      @@component_instances_list << self
      puts "created"
    end

    def add_child(c)
      if @children == nil
      	puts "value is #{@children}"
        @chilren << c unless @children.include? c
      else
      	@children = [c]
      end
    end

    def remove_child(c)
  	  @children.delete(c) if @children
    end

    def add_parent(p)
      if @parents
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
        else
        	return nil
        end
      end
      return nil
    end

    def self.show
    	puts "total numbe of components: #{@@component_instances_list.size}"
    	@@component_instances_list.each do |comp|
    	  puts "NAME: #{comp.name}"
    	  puts "PARENTS: #{comp.parents.each {|p| puts p}}"
    	  puts "CHILDREN: #{comp.children.each {|c| puts c}}"
    	end
    end

  end 
  LIST = []
  sample_input = []
  File.open('sample_input.txt').each do |line|
    sample_input  << line.split(" ")
  end

  sample_input.each do |command|
    case command[0]
    when 'DEPEND'
    	for index in 1..command.size
          comp = Component.find_by(command[index])
          comp = Component.new(command[index]) unless comp
          for parent_index in (index+1)..command.size
          	comp.add_parent((command[parent_index])) if command[parent_index]
          end
        end
        for second_index in (command.size).downto(1)
        	comp = Component.find_by(command[second_index])
        	comp = Component.new(command[second_index]) unless comp
        	for child_index in (index-1).downto(1)
          	  comp.add_child(command[child_index]) if command[child_index]
            end
        end

    end

  Component.show

  end

end