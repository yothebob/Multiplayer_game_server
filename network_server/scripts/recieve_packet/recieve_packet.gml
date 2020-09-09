// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function recieved_packet(_buffer,_socket){
mesid = buffer_read(_buffer,buffer_u8);

switch(mesid)
{
case network.player_establish:
		
	var _username = buffer_read(_buffer,buffer_string);	
		network_player_join(_username);
	break;


case network.move:
	var move_x = buffer_read(_buffer,buffer_u16);
	var move_y = buffer_read(_buffer,buffer_u16);

	var _player = ds_map_find_value(socket_to_instanceid,socket);
	_player.x = move_x;
	_player.y = move_y;

	var i = 0;
	repeat(ds_list_size(socket_list))
	{
	var _sock = ds_list_find_value(socket_list,i);
	buffer_seek(server_buffer,buffer_seek_start,0);
	buffer_write(server_buffer,buffer_u8,network.move);
	buffer_write(server_buffer,buffer_u8,socket);
	buffer_write(server_buffer,buffer_u16,move_x);
	buffer_write(server_buffer,buffer_u16,move_y);
	network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
	
	i+=1;
	}

	
	
	
	break;

}
}