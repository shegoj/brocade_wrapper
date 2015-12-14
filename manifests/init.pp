# Class: brocade_wrapper
# ===========================
#
class brocade_wrapper () {

                include 'stdlib'
                notice ("works a treat")
                notice (grab_nodes(100))
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


}

