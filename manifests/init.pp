# Class: graphite
# ===========================
#
class brocade_wrapper {



		include 'stdlib'


		############### Steel Apps config  ########################

		$steelapp_server = hiera_hash ('steelapp-server')
		$server = $steelapp_server['server']
		$port = $steelapp_server['port']
		$user = $steelapp_server['user']
		$password = $steelapp_server['pass']


		class { 'brocadevtm':
				    rest_user => "${user}",
				    rest_pass => "${password}",
				    #rest_ip   => '10.65.84.72',
				    rest_ip   => "${server}",
				    rest_port  => "${port}",
		}

		###  configure Trafic IP Group  ###################

		$traffic_ip_group = hiera_hash ('traffic-ip-group')
		$traffic_ip_group.each | String $traffic_ip_group_name, $config | {

				    brocadevtm::traffic_ip_groups { "${traffic_ip_group_name}":
				            ensure                         =>                               present,
				            basic__mode                    =>                               'multihosted',
				            basic__multicast               =>                               '239.191.130.52',
				            basic__machines                =>                               $config['machines'],
				            basic__keeptogether            =>                               'true',
				            basic__ipaddresses             =>                               $config['ipaddresses'],
				            basic__hash_source_port        =>                               'true',
				  }

		}

		###  configure Virtual servers ###################

		$virtual_servers = hiera_hash ('virtual-servers')

		$virtual_servers.each | String $virtual_server_name, $config | {
				    brocadevtm::virtual_servers { "${virtual_server_name}":
				            ensure                                                                          => present,
				            basic__pool                                                                     => $config['pool'],
				            basic__listen_on_traffic_ips                                                    => $config['listen-ontraffic-ips'],
				            basic__port                                                                     => 80,
				    }

		}

		###  configure Pools  ###################

		$pools = hiera_hash ('pools')
		$pools.each |  $pool_name, $config | {
				    $monitors = $config['monitors']
				    $nodes = []
				    $data=""
				    $config['nodes'].each | $node | {
				            $data ="{\"node\": $node,\"priority\":1,\"state\":\"active\",\"weight\":1}"
				            #$nodes  = concat ($nodes,$data)
				            $nodes  = $nodes + $data
				    }

				    brocadevtm::pools { "$pool_name":
				            ensure             => present,
				            basic__nodes_table => '[{"node":"10.1.1.1:80","priority":1,"state":"active","weight":1},{"node":"11.1.1.1:80","priority":1,"state":"active","weight":1}]',
				            #basic__nodes_table => "${nodes}",
				            #basic__monitors    => $config['monitors'],
				            basic__monitors    => ["monitors"],
				   }
		}


		###  configure Virtual servers ###################

		$monitors = hiera_hash ('monitors')

		$monitors.each | String $monitor_name, $config | {
				    brocadevtm::monitors { "$monitor_name":
				            ensure        => present,
				            http__path    =>  "${config["path"]}",
				    }
				    notice (" monitor name ${config["path"]} ")
		}
}
