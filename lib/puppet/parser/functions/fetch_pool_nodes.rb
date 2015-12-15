module Puppet::Parser::Functions
  newfunction(:fetch_pool_nodes, :type => :rvalue) do |args|
    node_val=""
    rtn = []

    for node in args[0]
      node_val =  "\{\"node\":\"#{node}\" , \"priority\":1,\"state\":\"active\",\"weight\":1 \}"
      rtn << (node_val)
    end
    rtn
  end
end
