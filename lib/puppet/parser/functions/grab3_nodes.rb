module Puppet::Parser::Functions
	newfunction(:grab2_nodes, :type => :rvalue) do |args|
		#rand(args.empty? ? 0 : args[0])
	   for number in args[0]
				#{number}
     end
  end
end

