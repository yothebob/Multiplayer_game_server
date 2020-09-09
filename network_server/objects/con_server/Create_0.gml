/// @description Insert description here
// You can write your code in this editor

enum network
{	player_establish,
	player_connect,
	player_joined,
	player_disconnect,
	move,

}

port = 64198; // filler number
max_client = 20;
buffer_size = 1024;
network_create_server(network_socket_tcp,port,max_client);

server_buffer = buffer_create(buffer_size,buffer_fixed,1);

socket_list = ds_list_create();
socket_to_instanceid = ds_map_create();

playerspawn_x = 100;
playerspawn_y = 100;