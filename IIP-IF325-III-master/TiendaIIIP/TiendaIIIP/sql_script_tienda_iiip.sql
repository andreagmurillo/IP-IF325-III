create database TiendaIIIP
go

use TiendaIIIP
go


create table usuario (
	idUsuario int primary key not null,
	nombre varchar(25) not null,
	apellido varchar(25) not null,
	nombreUsuario varchar(25) not null,
	psw varchar(40) not null,
	rol char(15) not null,
	estado char(20) not null
)

alter table usuario add correo varchar(45) 


select * from usuario


---------------PROCEDIMIENTOS ALMACENADOS, STORE PROCEDURE CRUD----------------

alter procedure insertarUsuario 
	@idUsuario int, @nombre varchar(25),
	@apellido varchar(25), @userName varchar(25),
	@psw varchar(25), @rol char(15), @estado char(20), 
	@correo varchar(50)
	as begin
		if exists (select nombreUsuario from usuario where nombreUsuario=@userName and estado='activo')
		raiserror ('Ya existe un registro con ese usuario, porfavor ingrese uno nuevo',16,1)
		else
		insert into usuario values(@idUsuario, @nombre, @apellido, @userName,@psw, @rol, @estado, @correo) 
	end

execute insertarUsuario 3, 'Olman', 'Mendez', 'olmanmendez', '123','admin','activo', 'olmmendez@unicah.edu'
execute insertarUsuario 4, 'Luis', 'Lopez', 'llopez', '123','cajero','activo', 'luislopez@unicah.edu'


----------------------------UPDATE--------------------------------------
alter procedure modificarUsuario 
	@idUsuario int, @nombre varchar(25), 
	@apellido varchar(25), @userName varchar(25), 
	@psw varchar(25), @rol char(15), @correo varchar(50)
	as begin 
		if exists(select nombreUsuario,idUsuario from usuario where 
					(nombreUsuario = @userName and idUsuario <> @idUsuario and estado = 'activo') or 
					(nombre=@nombre and idUsuario <> @idUsuario and estado= 'activo'))
		raiserror ('Usuario esta en uso, utiliza otro por favor', 16,1)
		else
		update usuario set nombre = @nombre, apellido =@apellido, psw = @psw, rol = @rol, correo = @correo
		where idUsuario = @idUsuario
	end

	------------------DELETE----------
	create procedure eliminarUsuario 
	@idUsuario int, @rol varchar(50)
	as begin 
		if exists (select nombreUsuario from usuario where @rol = 'admin')
			raiserror ('El usuario *Admin* no se puede eliminar, Accion denegada',16,1)
		else
			update usuario set estado = 'eliminado'
			where idUsuario = @idUsuario and rol <> 'admin'
	end

	select * from usuario

	-------Buscar usuario por nombre de usuario---

	create procedure buscarUsuario 
	@userName varchar(50)
	as begin
		select CONCAT(nombre, ' ', apellido) as 'Nombre completo', nombreUsuario as 'Usuario', 
				estado as 'Estado', rol as 'Puesto', correo as 'Correo' 
		from usuario
		where nombreUsuario like '%' +@userName+ '%'
	end

	execute buscarUsuario 'p'