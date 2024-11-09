create table empresa(
	rut varchar(15) primary key,
	nombre varchar(100) not null,
	direccion varchar(150),
	telefono varchar(20),
	correo varchar(50),
	web varchar(100)
);

create table cliente(
	rut varchar(15) primary key,
	nombre varchar(100) not null,
	correo varchar(50),
	direccion varchar(150),
	celular varchar(20),
	alta boolean not null
);

create table tipovehiculo(
	idtipovehiculo serial primary key,
    nombre varchar(100) not null
);

create table marca (
    idmarca serial primary key,
    nombre varchar(100) not null
);

create table vehiculo(
    idvehiculo serial primary key,
    patente varchar(10) unique not null,
    marca int not null,
    modelo varchar(30),
    color varchar(15),
    precio int not null,
    frecuenciamantencion int,
    idtipovehiculo int not null,
    foreign key (marca) references marca(idmarca),
    foreign key (idtipovehiculo) references tipovehiculo(idtipovehiculo)
);

create table venta(
    folio int primary key,
    fecha date not null,
    monto int not null,
    rutcliente varchar(15) not null,
    idvehiculo int not null,
    foreign key (rutcliente) references cliente(rut),
    foreign key (idvehiculo) references vehiculo(idvehiculo)
);

create table mantencion(
    idmantencion serial primary key,
    fecha date,
    trabajosrealizados text,
    idfolio int not null,
    foreign key (idfolio) references venta(folio)
);

