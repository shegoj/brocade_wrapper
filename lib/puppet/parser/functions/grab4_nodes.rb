module Puppet::Parser::Functions
	newfunction(:grab3_nodes, :type => :rvalue) do |args|
		#rand(args.empty? ? 0 : args[0])
		 nodes = args [0]
	   nodes.each_index do |i|
				nodes[i]
				i
     end
  end
end

