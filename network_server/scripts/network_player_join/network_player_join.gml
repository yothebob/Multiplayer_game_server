// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function network_player_join(_username){

	//create player in server
var _player = instance_create_depth(playerspawn_x,playerspawn_y,depth,obj_player);
_player.username = _username; //give username

// add instance ID of obj_player to socket list (ds_map)
			ds_map_add(socket_to_instanceid,socket,_player);
		
	#region // create obj_player for connection to client
			buffer_seek(server_buffer,buffer_seek_start,0);
			buffer_write(server_buffer,buffer_u8,network.player_connect);
			buffer_write(server_buffer,buffer_u8,socket);
			buffer_write(server_buffer,buffer_u16,_player.x);
			buffer_write(server_buffer,buffer_u16,_player.y);
			buffer_write(server_buffer,buffer_string,_player.username);
			network_send_packet(socket,server_buffer,buffer_tell(server_buffer));
	#endregion
			
	#region // send allready joined clients to connecting clients
		var i = 0;
			repeat(ds_list_size(socket_list))
			{
		var _sock = ds_list_find_value(socket_list,i);
			if _sock != socket
				{
				var _slave = ds_map_find_value(socket_to_instanceid,_sock);
				
				buffer_seek(server_buffer,buffer_seek_start,0);
				buffer_write(server_buffer,buffer_u8,network.player_joined);
				buffer_write(server_buffer,buffer_u8,_sock);
				buffer_write(server_buffer,buffer_u16,_slave.x);
				buffer_write(server_buffer,buffer_u16,_slave.y);
				buffer_write(server_buffer,buffer_string,_slave.username);
				network_send_packet(socket,server_buffer,buffer_tell(server_buffer));
				}
		i+=1;
		}
		
	#endregion	
		
	#region // so the old clients can see the newly joined client/s
		var i = 0;
		repeat(ds_list_size(socket_list))
			{
			var _sock = ds_list_find_value(socket_list,i);
			if _sock != socket
				{
				buffer_seek(server_buffer,buffer_seek_start,0);
				buffer_write(server_buffer,buffer_u8,network.player_joined);
				buffer_write(server_buffer,buffer_u8,socket);
				buffer_write(server_buffer,buffer_u16,_player.x);
				buffer_write(server_buffer,buffer_u16,_player.y);
				buffer_write(server_buffer,buffer_string,_player.username);
				network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
				}
			i+= 1;
			}
	#endregion
}
