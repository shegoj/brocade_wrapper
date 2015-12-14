module Puppet::Parser::Functions
	newfunction(:grab2_nodes, :type => :rvalue) do |args|
		#rand(args.empty? ? 0 : args[0])
		 args.empty? ? 0 : args[0]
  end
end
