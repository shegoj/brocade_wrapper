# Class: brocade_wrapper
# ===========================
#
class brocade_wrapper () {
	############### Steel Apps config  ########################

	$steelapp_server = hiera_hash ('steelapp-server', undef)
	$server = $steelapp_server['server']
	$port = $steelapp_server['port']
	$user = $steelapp_server['user']
	$password = $steelapp_server['pass']

	class { 'brocadevtm':
		rest_user => "${user}",
		rest_pass => "${password}",
		rest_ip   => "${server}",
		rest_port => "${port}",
	}

	###  configure Trafic IP Group  ###################

	$traffic_ip_group = hiera_hash ('steelapp::traffic-ip-group',undef)

	if ($traffic_ip_group != undef) {
		$traffic_ip_group.each | String $traffic_ip_group_name, $config | {

		  brocadevtm::traffic_ip_groups { "${traffic_ip_group_name}":
		          ensure                         =>    present,
		          basic__mode                    =>    'multihosted',
		          basic__multicast               =>     config['multicast'],
		          basic__machines                =>     $config['machines'],
		          basic__keeptogether            =>     'true',
		          basic__ipaddresses             =>     $config['ipaddresses'],
		          basic__hash_source_port        =>     'true',
			}

		}
	}

	###  configure Virtual servers ###################

	$virtual_servers = hiera_hash ('steelapp::virtual-servers', undef)

	if ( $virtual_servers != undef) {
		$virtual_servers.each | String $virtual_server_name, $config | {
			brocadevtm::virtual_servers { "${virtual_server_name}":
        ensure													=> present,
        basic__pool											=> $config['pool'],
        basic__listen_on_traffic_ips		=> $config['listen-ontraffic-ips'],
        basic__port											=> 80,
		  }
		}
	}


	###  configure Pools  ###################
	$pools = hiera_hash ('steelapp::pools', undef)
	if ( $pools != undef) {
		$pools.each |  $pool_name, $config | {
			$monitors = $config['monitors']
			$pool_nodes = fetch_pool_nodes($config['nodes'])

      brocadevtm::pools { "$pool_name":
              ensure             => present,
              basic__nodes_table => "${pool_nodes}",
              basic__monitors    => ["monitors"],
			}
		}
	}

	###  configure Monitors ###################

	$monitors = hiera_hash ('steelapp::monitors')
	if ($monitors != undef ) {

		$monitors.each | String $monitor_name, $config | {
			brocadevtm::monitors { "$monitor_name":
      	ensure        => present,
        http__path    =>  "${config["path"]}",
      }
		}
	}

}



