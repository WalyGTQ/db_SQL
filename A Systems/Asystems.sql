-- Crear base de datos
CREATE DATABASE IF NOT EXISTS asystemsdb;
USE asystemsdb;

create table articulo_categoria
(
    id          int auto_increment
        primary key,
    nombre      varchar(50)  not null,
    descripcion varchar(255) null,
    constraint nombre
        unique (nombre)
)
    engine = InnoDB;

create table articulo_disponibilidad
(
    id     int auto_increment
        primary key,
    nombre varchar(30) not null,
    constraint nombre
        unique (nombre)
)
    engine = InnoDB;

create table articulo_estado
(
    id     int auto_increment
        primary key,
    nombre varchar(30) not null,
    constraint nombre
        unique (nombre)
)
    engine = InnoDB;

create table bodegas
(
    id        int auto_increment
        primary key,
    nombre    varchar(50)  not null,
    ubicacion varchar(100) null
)
    engine = InnoDB;

create table contabilidad_banco_tipos
(
    id          int auto_increment
        primary key,
    abreviatura varchar(10)  not null comment 'Ej: MON, AHO, CC',
    nombre      varchar(50)  not null comment 'Ej: Monetaria, Ahorro',
    descripcion varchar(255) null
)
    engine = InnoDB;

create table documento_estado_pago
(
    id      int auto_increment
        primary key,
    nombre  varchar(50)          not null,
    detalle varchar(255)         null,
    estado  tinyint(1) default 1 null
)
    engine = InnoDB
    charset = utf8mb4;

create table documento_serie_fel
(
    id        int auto_increment
        primary key,
    prefijo   varchar(50)            not null,
    separador varchar(5) default '-' null,
    nombre    varchar(100)           not null,
    detalles  text                   null
)
    engine = InnoDB
    charset = utf8mb4;

create table documentos_series
(
    id        int auto_increment
        primary key,
    prefijo   varchar(10)            not null,
    separador varchar(5) default '-' null,
    nombre    varchar(100)           not null,
    detalles  text                   null
)
    engine = InnoDB
    charset = utf8mb4;

create table documentos_tipo
(
    id          int auto_increment
        primary key,
    tipo        varchar(50)          not null,
    descripcion varchar(255)         null,
    estado      tinyint(1) default 1 null
)
    engine = InnoDB
    charset = utf8mb4;

create table empresa_regimen
(
    id          int auto_increment
        primary key,
    porcentaje  decimal(5, 2) not null,
    nombre      varchar(50)   not null,
    descripcion text          null
)
    engine = InnoDB;

create table empresas
(
    id              int auto_increment
        primary key,
    nombre          varchar(100)                                                        not null,
    nit             varchar(20)                                                         not null,
    direccion       text                                                                null,
    telefono        varchar(20)                                                         null,
    correo          varchar(100)                                                        null,
    regimen_fiscal  enum ('PEQUENO_CONTRIBUYENTE', 'GENERAL') default 'GENERAL'         null,
    moneda_base     char(3)                                   default 'GTQ'             null,
    ruta_logo       varchar(255)                                                        null,
    sitio_web       varchar(100)                                                        null,
    configuraciones json                                                                null comment 'Configuraciones flexibles (colores, formatos)',
    creado_en       timestamp                                 default CURRENT_TIMESTAMP null
)
    engine = InnoDB;

create table eventos_calendario
(
    id                 bigint auto_increment
        primary key,
    titulo             varchar(100)                                                  not null,
    fecha_inicio       datetime                                                      not null,
    fecha_fin          datetime                                                      null,
    tipo               enum ('PAYMENT_REMINDER', 'COLLECTION', 'TAX_DUE', 'MEETING') not null,
    doc_relacionado_id bigint                                                        null,
    esta_completado    tinyint(1) default 0                                          null
)
    engine = InnoDB;

create table licencias_sistema
(
    id                int auto_increment
        primary key,
    empresa_id        int                                                      not null,
    clave_licencia    varchar(255)                                             not null,
    hash_licencia     varchar(255)                                             not null,
    valido_hasta      datetime                                                 not null,
    estado            enum ('ACTIVE', 'SUSPENDED', 'EXPIRED') default 'ACTIVE' null,
    ultimo_chequeo_en datetime                                                 null,
    constraint clave_licencia
        unique (clave_licencia),
    constraint licencias_sistema_ibfk_1
        foreign key (empresa_id) references empresas (id)
)
    engine = InnoDB;

create table log_tareas_automaticas
(
    id                 int auto_increment
        primary key,
    nombre_tarea       varchar(100)                        not null,
    ultima_ejecucion   datetime                            not null,
    ultimo_exito       datetime                            null,
    ultimo_error       text                                null,
    conteo_ejecuciones int       default 0                 null,
    conteo_errores     int       default 0                 null,
    creado_en          timestamp default CURRENT_TIMESTAMP null,
    actualizado_en     timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint nombre_tarea
        unique (nombre_tarea)
)
    engine = InnoDB;

create index idx_log_tareas_fecha
    on log_tareas_automaticas (ultima_ejecucion);

create index idx_log_tareas_nombre
    on log_tareas_automaticas (nombre_tarea);

create table monedas
(
    id          int auto_increment
        primary key,
    signo       varchar(5)  not null,
    nombre      varchar(50) not null,
    descripcion text        null
)
    engine = InnoDB;

create table contabilidad_cajas
(
    id             int auto_increment
        primary key,
    nombre_caja    varchar(100)                             not null,
    color_tarjeta  varchar(7)     default '#fc7d04'         null comment 'Color hex para identificar la caja en la UI',
    moneda_id      int                                      not null,
    saldo_inicial  decimal(15, 2) default 0.00              null,
    saldo_actual   decimal(15, 2) default 0.00              null,
    saldo_final    decimal(15, 2) default 0.00              null,
    creado_en      timestamp      default CURRENT_TIMESTAMP null,
    actualizado_en timestamp      default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint fk_caja_moneda
        foreign key (moneda_id) references monedas (id)
)
    engine = InnoDB;

create table periodos_fiscales
(
    id           int auto_increment
        primary key,
    fecha_inicio datetime                not null,
    estado       char(20) default 'OPEN' null,
    fecha_fin    datetime                null,
    codigo       char(50)                null,
    nombre       char(100)               null
)
    engine = InnoDB;

create table plan_cuentas
(
    id         int auto_increment
        primary key,
    codigo     varchar(20)                                                 not null comment 'Ej: 1.1.01',
    nombre     varchar(100)                                                not null,
    tipo       enum ('ACTIVO', 'PASIVO', 'PATRIMONIO', 'INGRESO', 'GASTO') not null,
    padre_id   int                                                         null,
    es_movible tinyint(1)     default 1                                    null comment 'Si acepta asientos o es solo categoria',
    saldo      decimal(15, 2) default 0.00                                 null,
    constraint plan_cuentas_ibfk_1
        foreign key (padre_id) references plan_cuentas (id)
)
    engine = InnoDB;

create table contabilidad_bancos
(
    id                 int auto_increment
        primary key,
    nombre_banco       varchar(50)                      not null,
    numero_cuenta      varchar(50)                      not null,
    moneda_id          int                              null,
    tipo_id            int                              null,
    color_tarjeta      varchar(7)     default '#3B82F6' null comment 'Color de la tarjeta en formato hexadecimal (#RRGGBB)',
    saldo_actual       decimal(15, 2) default 0.00      null,
    cuenta_contable_id int                              null,
    constraint fk_banco_moneda
        foreign key (moneda_id) references monedas (id),
    constraint fk_banco_tipo
        foreign key (tipo_id) references contabilidad_banco_tipos (id),
    constraint fk_bank_acc
        foreign key (cuenta_contable_id) references plan_cuentas (id)
)
    engine = InnoDB;

create table roles
(
    id          int auto_increment
        primary key,
    nombre      varchar(50) not null,
    permissions json        null comment 'Lista de permisos: {"ver_reportes": true, "crear_usuarios": false}',
    constraint nombre
        unique (nombre)
)
    engine = InnoDB;

create table socios_negocio
(
    id                    int auto_increment
        primary key,
    empresa_id            int                                                   not null,
    tipo                  enum ('PERSONA', 'EMPRESA') default 'EMPRESA'         null,
    identificacion_fiscal varchar(20)                                           not null comment 'NIT o DPI',
    nombre                varchar(150)                                          not null comment 'Razón Social o Nombre',
    nombre_comercial      varchar(150)                                          null,
    correo                varchar(100)                                          null,
    telefono              varchar(20)                                           null,
    direccion             text                                                  null,
    es_cliente            tinyint(1)                  default 0                 null,
    es_proveedor          tinyint(1)                  default 0                 null,
    limite_credito        decimal(15, 2)              default 0.00              null,
    dias_terminos_pago    int                         default 0                 null comment 'Días de crédito',
    lista_precios_id      int                                                   null comment 'Lista de precios asignada',
    creado_en             timestamp                   default CURRENT_TIMESTAMP null,
    activo                tinyint(1)                  default 1                 not null comment '0 = Inactivo, 1 = Activo',
    constraint socios_negocio_ibfk_1
        foreign key (empresa_id) references empresas (id)
)
    engine = InnoDB;

create table saldo_credito_socio
(
    id                   int auto_increment
        primary key,
    socio_id             int                                      not null,
    saldo                decimal(15, 2) default 0.00              not null,
    ultima_actualizacion timestamp      default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    creado_en            timestamp      default CURRENT_TIMESTAMP null,
    constraint unique_socio
        unique (socio_id),
    constraint saldo_credito_socio_ibfk_1
        foreign key (socio_id) references socios_negocio (id)
            on delete cascade
)
    engine = InnoDB;

create table suscripciones
(
    id                        int auto_increment
        primary key,
    socio_id                  int                                                     not null,
    servicio_id               int                                                     not null comment 'Relacion a tabla productos',
    monto                     decimal(15, 2)                                          not null,
    frecuencia                enum ('MONTHLY', 'YEARLY', 'WEEKLY')                    not null,
    proxima_fecha_facturacion date                                                    not null,
    estado                    enum ('ACTIVE', 'PAUSED', 'CANCELLED') default 'ACTIVE' null,
    constraint suscripciones_ibfk_1
        foreign key (socio_id) references socios_negocio (id)
)
    engine = InnoDB;

create table transacciones_bancarias
(
    id                  bigint auto_increment
        primary key,
    cuenta_id           int                                                           not null,
    fecha               date                                                          not null,
    tipo                enum ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER_IN', 'TRANSFER_OUT') not null,
    metodo              enum ('CASH', 'CHECK', 'TRANSFER', 'CARD')                    not null,
    referencia          varchar(50)                                                   null,
    monto               decimal(15, 2)                                                not null,
    descripcion         text                                                          null,
    conciliado          tinyint(1)     default 0                                      null,
    documento_id        bigint                                                        null comment 'Relación con el pago de una factura',
    factura_especial_id int                                                           null,
    creado_en           timestamp      default CURRENT_TIMESTAMP                      null,
    aplicado_auto       tinyint(1)     default 0                                      null comment 'Si el pago fue aplicado automáticamente a facturas',
    monto_restante      decimal(15, 2) default 0.00                                   null comment 'Monto restante después de aplicar a facturas',
    constraint fk_transacciones_banco
        foreign key (cuenta_id) references contabilidad_bancos (id)
)
    engine = InnoDB;

create index idx_transacciones_cuenta
    on transacciones_bancarias (cuenta_id);

create table usuarios
(
    id             int auto_increment
        primary key,
    empresa_id     int                                                   null,
    rol_id         int                         default 3                 not null,
    nombre         varchar(100)                                          not null,
    apellido       varchar(100)                                          not null,
    email          varchar(150)                                          not null,
    telefono       varchar(20)                                           null,
    username       varchar(50)                                           not null,
    password       varchar(255)                                          not null,
    activo         tinyint(1)                  default 0                 null,
    estado         enum ('ACTIVE', 'INACTIVE') default 'ACTIVE'          null,
    ultimo_login   datetime                                              null,
    token          varchar(100)                                          null,
    fecha_registro timestamp                   default CURRENT_TIMESTAMP null,
    creado_en      timestamp                   default CURRENT_TIMESTAMP null,
    actualizado_en timestamp                   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint email
        unique (email),
    constraint username
        unique (username),
    constraint usuarios_ibfk_1
        foreign key (empresa_id) references empresas (id),
    constraint usuarios_ibfk_2
        foreign key (rol_id) references roles (id)
)
    engine = InnoDB;

create table articulo
(
    id                        int auto_increment
        primary key,
    sku                       varchar(50)                                                    null,
    barcode                   varchar(100)                                                   null,
    titulo                    varchar(150)                                                   not null,
    descripcion               text                                                           null,
    tipo                      enum ('PRODUCTO', 'SERVICIO', 'KIT') default 'PRODUCTO'        null,
    metodo_costo              enum ('AVG', 'FIFO')                 default 'AVG'             null,
    cantidad_disponible       int                                  default 0                 not null,
    stock_minimo              int                                  default 0                 null,
    stock_maximo              int                                  default 100               null,
    costo_base                decimal(15, 2)                       default 0.00              null,
    precio_base               decimal(15, 2)                       default 0.00              null,
    tasa_impuesto             decimal(5, 2)                        default 12.00             null,
    esta_activo               tinyint(1)                           default 1                 null,
    cuenta_ingreso_id         int                                                            null,
    id_categoria              int                                                            not null,
    id_estado                 int                                                            not null,
    id_disponibilidad         int                                                            not null,
    id_usuario_creador        int                                                            not null,
    fecha_creacion            datetime                             default CURRENT_TIMESTAMP null,
    fecha_ultima_modificacion datetime                             default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint sku
        unique (sku),
    constraint articulo_ibfk_1
        foreign key (id_categoria) references articulo_categoria (id),
    constraint articulo_ibfk_2
        foreign key (id_estado) references articulo_estado (id),
    constraint articulo_ibfk_3
        foreign key (id_disponibilidad) references articulo_disponibilidad (id),
    constraint articulo_ibfk_4
        foreign key (id_usuario_creador) references usuarios (id),
    constraint fk_articulo_income
        foreign key (cuenta_ingreso_id) references plan_cuentas (id)
)
    engine = InnoDB;

create index idx_articulo_cat
    on articulo (id_categoria);

create index idx_articulo_disp
    on articulo (id_disponibilidad);

create index idx_articulo_est
    on articulo (id_estado);

create index idx_articulo_user
    on articulo (id_usuario_creador);

create table articulo_computadora
(
    id                    int auto_increment
        primary key,
    id_articulo           int          not null,
    modelo                varchar(100) not null,
    procesador            varchar(100) not null,
    ram                   varchar(50)  not null,
    almacenamiento        varchar(100) not null,
    pantalla              varchar(100) null,
    sistema_operativo     varchar(100) null,
    otras_caracteristicas text         null,
    constraint id_articulo_unique
        unique (id_articulo),
    constraint articulo_computadora_ibfk_1
        foreign key (id_articulo) references articulo (id)
            on delete cascade
)
    engine = InnoDB;

create table articulo_imagenes
(
    id           int auto_increment
        primary key,
    id_articulo  int                                  not null,
    ruta_imagen  varchar(255)                         not null,
    es_principal tinyint(1) default 0                 null,
    orden        int        default 0                 null,
    fecha_subida datetime   default CURRENT_TIMESTAMP null,
    constraint articulo_imagenes_ibfk_1
        foreign key (id_articulo) references articulo (id)
            on delete cascade
)
    engine = InnoDB;

create table articulo_precio
(
    id                int auto_increment
        primary key,
    id_articulo       int                                  not null,
    precio            decimal(10, 2)                       not null,
    moneda            varchar(3) default 'GTQ'             null,
    fecha_establecido datetime   default CURRENT_TIMESTAMP null,
    constraint articulo_precio_ibfk_1
        foreign key (id_articulo) references articulo (id)
            on delete cascade
)
    engine = InnoDB;

create table bitacora
(
    id             int auto_increment
        primary key,
    usuario_id     int                                 not null,
    accion         varchar(100)                        not null,
    tabla          varchar(50)                         null,
    registro_id    int                                 null,
    detalles       json                                null,
    ip_direccion   varchar(45)                         null,
    user_agent     text                                null,
    fecha_registro timestamp default CURRENT_TIMESTAMP null,
    constraint bitacora_ibfk_1
        foreign key (usuario_id) references usuarios (id)
)
    engine = InnoDB;

create table detalles_documento
(
    id              int auto_increment
        primary key,
    documento_id    bigint                      not null,
    articulo_id     int                         null,
    descripcion     varchar(255)                not null,
    cantidad        decimal(10, 2)              not null,
    precio_unitario decimal(15, 2)              not null,
    descuento       decimal(10, 2) default 0.00 null,
    total           decimal(15, 2)              not null,
    constraint fk_detalles_articulo
        foreign key (articulo_id) references articulo (id)
)
    engine = InnoDB;

create index idx_detalles_doc
    on detalles_documento (documento_id);

create table documentos
(
    id                bigint auto_increment
        primary key,
    tipo_documento_id int                                      null,
    estado_pago_id    int                                      null,
    serie_id          int                                      null,
    serie_fel_id      int                                      null,
    moneda_id         int                                      null,
    regimen_id        int                                      null,
    empresa_id        int                                      not null,
    socio_id          int                                      not null,
    numero            varchar(20)                              not null,
    fecha_emision     date                                     not null,
    fecha_vencimiento date                                     not null,
    tipo_cambio       decimal(10, 4) default 1.0000            null,
    subtotal          decimal(15, 2)                           not null,
    monto_impuesto    decimal(15, 2)                           not null,
    monto_descuento   decimal(15, 2) default 0.00              null,
    total             decimal(15, 2)                           not null,
    saldo_pendiente   decimal(15, 2)                           not null comment 'Lo que falta por pagar/cobrar',
    fel_uuid          varchar(100)                             null,
    fel_numero        varchar(50)                              null,
    usuario_id        int                                      not null,
    creado_en         timestamp      default CURRENT_TIMESTAMP null,
    constraint documentos_ibfk_1
        foreign key (socio_id) references socios_negocio (id),
    constraint documentos_ibfk_2
        foreign key (empresa_id) references empresas (id),
    constraint documentos_ibfk_3
        foreign key (usuario_id) references usuarios (id),
    constraint fk_documentos_estado_pago
        foreign key (estado_pago_id) references documento_estado_pago (id),
    constraint fk_documentos_monedas
        foreign key (moneda_id) references monedas (id),
    constraint fk_documentos_regimen
        foreign key (regimen_id) references empresa_regimen (id),
    constraint fk_documentos_serie_fel
        foreign key (serie_fel_id) references documento_serie_fel (id),
    constraint fk_documentos_series
        foreign key (serie_id) references documentos_series (id),
    constraint fk_documentos_tipo
        foreign key (tipo_documento_id) references documentos_tipo (id)
)
    engine = InnoDB;

create table aplicaciones_pago
(
    id             int auto_increment
        primary key,
    transaccion_id bigint                              not null comment 'ID de transacciones_bancarias',
    documento_id   bigint                              not null,
    monto_aplicado decimal(15, 2)                      not null,
    aplicado_en    timestamp default CURRENT_TIMESTAMP null,
    constraint aplicaciones_pago_ibfk_1
        foreign key (transaccion_id) references transacciones_bancarias (id)
            on delete cascade,
    constraint aplicaciones_pago_ibfk_2
        foreign key (documento_id) references documentos (id)
            on delete cascade
)
    engine = InnoDB;

create index idx_documentos_empresa
    on documentos (empresa_id);

create index idx_documentos_socio
    on documentos (socio_id);

create table eventos_entrada_salida
(
    id                 int auto_increment
        primary key,
    cuenta_id          int                                                                           not null comment 'Cuenta bancaria o caja afectada',
    usuario_id         int                                                                           not null comment 'Usuario que realizó la operación',
    transaccion_id     bigint                                                                        null comment 'Referencia a transacciones_bancarias si aplica',
    tipo_evento        enum ('ENTRADA', 'SALIDA', 'AJUSTE', 'TRANSFERENCIA_IN', 'TRANSFERENCIA_OUT') not null comment 'Tipo de movimiento',
    fecha_evento       datetime  default CURRENT_TIMESTAMP                                           not null comment 'Fecha y hora del evento',
    monto              decimal(15, 4)                                                                not null comment 'Monto del movimiento',
    saldo_anterior     decimal(15, 4)                                                                not null comment 'Saldo anterior',
    saldo_nuevo        decimal(15, 4)                                                                not null comment 'Saldo posterior',
    descripcion        varchar(500)                                                                  null comment 'Descripción del movimiento',
    justificacion      text                                                                          null comment 'Justificación detallada del cambio (especialmente para ajustes manuales)',
    referencia         varchar(100)                                                                  null comment 'Número de referencia (cheque, transferencia, etc.)',
    valores_anteriores json                                                                          null comment 'Valores anteriores si es una edición',
    valores_nuevos     json                                                                          null comment 'Valores nuevos si es una edición',
    creado_en          timestamp default CURRENT_TIMESTAMP                                           null,
    direccion_ip       varchar(45)                                                                   null comment 'Dirección IP del usuario',
    constraint eventos_entrada_salida_ibfk_2
        foreign key (usuario_id) references usuarios (id),
    constraint eventos_entrada_salida_ibfk_3
        foreign key (transaccion_id) references transacciones_bancarias (id)
            on delete set null,
    constraint fk_eventos_banco
        foreign key (cuenta_id) references contabilidad_bancos (id)
)
    engine = InnoDB;

create index idx_eventos_cuenta_fecha
    on eventos_entrada_salida (cuenta_id, fecha_evento);

create table facturas_especiales
(
    id             int auto_increment
        primary key,
    numero_factura varchar(50)                                            not null,
    socio_id       int                                                    not null,
    empresa_id     int                                                    not null,
    usuario_id     int                                                    not null,
    cuenta_id      int                                                    not null comment 'Cuenta bancaria donde ingresa el monto',
    fecha_emision  date                                                   not null,
    exento_iva     tinyint(1)                   default 1                 null comment 'Exonerado de IVA',
    subtotal       decimal(12, 2)               default 0.00              not null,
    descuento      decimal(12, 2)               default 0.00              not null,
    iva            decimal(12, 2)               default 0.00              not null,
    total          decimal(12, 2)                                         not null,
    notas          text                                                   null,
    estado         enum ('ACTIVE', 'CANCELLED') default 'ACTIVE'          null,
    creado_en      timestamp                    default CURRENT_TIMESTAMP null,
    actualizado_en timestamp                    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint numero_factura
        unique (numero_factura),
    constraint facturas_especiales_ibfk_1
        foreign key (socio_id) references socios_negocio (id),
    constraint facturas_especiales_ibfk_2
        foreign key (empresa_id) references empresas (id)
            on delete cascade,
    constraint facturas_especiales_ibfk_3
        foreign key (usuario_id) references usuarios (id),
    constraint fk_facturas_esp_banco
        foreign key (cuenta_id) references contabilidad_bancos (id)
)
    engine = InnoDB;

create table detalles_factura_especial
(
    id                  int auto_increment
        primary key,
    factura_especial_id int                                      not null,
    numero_linea        int                                      not null,
    fecha               date                                     not null,
    tipo_item           enum ('BIEN', 'SERVICIO')                not null comment 'Bien o Servicio',
    cantidad            decimal(10, 2) default 1.00              not null,
    descripcion         text                                     not null,
    precio_unitario     decimal(12, 2)                           not null,
    subtotal            decimal(12, 2)                           not null,
    descuento           decimal(12, 2) default 0.00              not null,
    total               decimal(12, 2)                           not null,
    creado_en           timestamp      default CURRENT_TIMESTAMP null,
    constraint detalles_factura_especial_ibfk_1
        foreign key (factura_especial_id) references facturas_especiales (id)
            on delete cascade
)
    engine = InnoDB;

create index idx_facturas_esp_cuenta
    on facturas_especiales (cuenta_id);

create index idx_facturas_esp_socio
    on facturas_especiales (socio_id);

create table historial_articulos
(
    id             int auto_increment
        primary key,
    articulo_id    int                                null,
    usuario_id     int                                not null,
    tipo_cambio    varchar(50)                        null,
    valor_anterior varchar(255)                       null,
    valor_nuevo    varchar(255)                       null,
    creado_en      datetime default CURRENT_TIMESTAMP null,
    constraint fk_historial_articulo
        foreign key (articulo_id) references articulo (id),
    constraint historial_articulos_ibfk_2
        foreign key (usuario_id) references usuarios (id)
)
    engine = InnoDB;

create index historial_productos_ibfk_2
    on historial_articulos (usuario_id);

create table kardex_inventario
(
    id          int auto_increment
        primary key,
    articulo_id int                                      null,
    fecha       datetime       default CURRENT_TIMESTAMP null,
    tipo        enum ('ENTRADA', 'SALIDA', 'AJUSTE')     not null,
    referencia  varchar(100)                             null,
    cantidad    decimal(10, 2)                           not null,
    costo_unid  decimal(10, 2) default 0.00              not null,
    stock_saldo decimal(10, 2)                           not null,
    usuario_id  int                                      null,
    constraint fk_kardex_articulo
        foreign key (articulo_id) references articulo (id),
    constraint kardex_inventario_ibfk_2
        foreign key (usuario_id) references usuarios (id)
)
    engine = InnoDB;

create index idx_kardex_producto
    on kardex_inventario (articulo_id);

create index idx_kardex_usuario
    on kardex_inventario (usuario_id);

create table logs_auditoria
(
    id                 bigint auto_increment
        primary key,
    usuario_id         int                                 null,
    accion             varchar(50)                         not null,
    nombre_tabla       varchar(50)                         null,
    registro_id        int                                 null,
    valores_anteriores json                                null,
    valores_nuevos     json                                null,
    direccion_ip       varchar(45)                         null,
    agente_usuario     varchar(255)                        null,
    creado_en          timestamp default CURRENT_TIMESTAMP null,
    constraint logs_auditoria_ibfk_1
        foreign key (usuario_id) references usuarios (id)
)
    engine = InnoDB;

create table movimientos_inventario
(
    id             bigint auto_increment
        primary key,
    articulo_id    int                                          null,
    bodega_id      int                                          not null,
    tipo           enum ('IN', 'OUT', 'ADJUSTMENT', 'TRANSFER') not null,
    cantidad       decimal(10, 2)                               not null,
    costo_unitario decimal(15, 2)                               not null,
    costo_total    decimal(15, 2)                               not null,
    doc_referencia varchar(50)                                  null comment 'N. Factura o Compra',
    creado_en      timestamp default CURRENT_TIMESTAMP          null,
    constraint fk_mov_articulo
        foreign key (articulo_id) references articulo (id),
    constraint movimientos_inventario_ibfk_2
        foreign key (bodega_id) references bodegas (id)
)
    engine = InnoDB;

create index idx_movimientos_bodega
    on movimientos_inventario (bodega_id);

create index idx_movimientos_prod
    on movimientos_inventario (articulo_id);

create table partidas_diario
(
    id              bigint auto_increment
        primary key,
    empresa_id      int                                                             not null,
    usuario_id      int                                                             not null,
    periodo_id      int                                                             not null,
    fecha           date                                                            not null,
    descripcion     text                                                            not null,
    tipo_referencia varchar(50)                                                     null,
    referencia_id   int                                                             null,
    total_debe      decimal(15, 2)                                                  not null,
    total_haber     decimal(15, 2)                                                  not null,
    estado          enum ('DRAFT', 'POSTED', 'CANCELLED') default 'POSTED'          null,
    creado_en       timestamp                             default CURRENT_TIMESTAMP null,
    constraint partidas_diario_ibfk_1
        foreign key (periodo_id) references periodos_fiscales (id),
    constraint partidas_diario_ibfk_2
        foreign key (empresa_id) references empresas (id),
    constraint partidas_diario_ibfk_3
        foreign key (usuario_id) references usuarios (id)
)
    engine = InnoDB;

create table lineas_diario
(
    id               bigint auto_increment
        primary key,
    partida_id       bigint                      not null,
    cuenta_id        int                         not null,
    descripcion      varchar(255)                null,
    debe             decimal(15, 2) default 0.00 null,
    haber            decimal(15, 2) default 0.00 null,
    centro_costos_id int                         null,
    constraint lineas_diario_ibfk_1
        foreign key (partida_id) references partidas_diario (id)
            on delete cascade,
    constraint lineas_diario_ibfk_2
        foreign key (cuenta_id) references plan_cuentas (id)
)
    engine = InnoDB;

create index idx_lineas_cuenta
    on lineas_diario (cuenta_id);

create index idx_lineas_partida
    on lineas_diario (partida_id);

create index idx_partidas_periodo
    on partidas_diario (periodo_id);

create table presupuestos
(
    id             int auto_increment
        primary key,
    usuario_id     int                                                                             not null,
    socio_id       int                                                                             null,
    solicitante    varchar(100)                                                                    not null,
    creador_id     int                                                                             not null,
    titulo         varchar(150)                                                                    not null,
    valido_hasta   date                                                                            not null,
    estado         enum ('pending', 'approved', 'cancelled', 'invoiced') default 'pending'         null,
    monto_total    decimal(15, 2)                                        default 0.00              not null,
    creado_en      timestamp                                             default CURRENT_TIMESTAMP null,
    actualizado_en timestamp                                             default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint presupuestos_ibfk_1
        foreign key (usuario_id) references usuarios (id)
            on delete cascade,
    constraint presupuestos_socio_fk
        foreign key (socio_id) references socios_negocio (id)
)
    engine = InnoDB;

create table historial_presupuestos
(
    id                 int auto_increment
        primary key,
    presupuesto_id     int                                 not null,
    usuario_id         int                                 not null,
    accion             varchar(50)                         not null comment 'CREATE, UPDATE, STATUS_CHANGE, DELETE, INVOICED',
    valores_anteriores json                                null,
    valores_nuevos     json                                null,
    creado_en          timestamp default CURRENT_TIMESTAMP null,
    constraint historial_presupuestos_presupuesto_fk
        foreign key (presupuesto_id) references presupuestos (id)
            on delete cascade,
    constraint historial_presupuestos_usuario_fk
        foreign key (usuario_id) references usuarios (id)
)
    engine = InnoDB;

create table items_presupuesto
(
    id              int auto_increment
        primary key,
    presupuesto_id  int                         not null,
    articulo_id     int                         null,
    descripcion     varchar(255)                not null,
    cantidad        decimal(10, 2) default 1.00 not null,
    precio_unitario decimal(15, 2)              not null,
    subtotal        decimal(15, 2)              not null,
    constraint fk_items_pres_articulo
        foreign key (articulo_id) references articulo (id),
    constraint items_presupuesto_ibfk_1
        foreign key (presupuesto_id) references presupuestos (id)
            on delete cascade
)
    engine = InnoDB;

create index idx_presupuestos_estado
    on presupuestos (estado);

create index idx_presupuestos_socio
    on presupuestos (socio_id);

create index idx_presupuestos_usuario
    on presupuestos (usuario_id);

create table servicios_recurrentes
(
    id                        int auto_increment
        primary key,
    socio_id                  int                                                                                                          not null comment 'Cliente al que se factura el servicio',
    articulo_id               int                                                                                                          null,
    usuario_id                int                                                                                                          not null comment 'Usuario propietario',
    creado_por                int                                                                                                          not null comment 'Usuario que creó el servicio recurrente',
    descripcion               text                                                                                                         null comment 'Descripción personalizada del servicio',
    monto                     decimal(10, 2)                                                                                               not null comment 'Monto a facturar cada ciclo',
    frecuencia                enum ('DAILY', 'WEEKLY', 'BIWEEKLY', 'MONTHLY', 'QUARTERLY', 'BIANNUAL', 'ANNUAL') default 'MONTHLY'         not null comment 'Frecuencia de facturación',
    fecha_inicio              date                                                                                                         not null comment 'Fecha de inicio del servicio',
    fecha_fin                 date                                                                                                         null comment 'Fecha de finalización (NULL = indefinido)',
    proxima_fecha_facturacion date                                                                                                         not null comment 'Próxima fecha de facturación',
    ultima_fecha_facturado    date                                                                                                         null comment 'Última fecha en que se facturó',
    estado                    enum ('active', 'paused', 'cancelled', 'completed')                                default 'active'          not null comment 'active: activo, paused: pausado, cancelled: cancelado, completed: finalizado',
    generar_auto              tinyint(1)                                                                         default 1                 null comment 'Generar facturas automáticamente (1=sí, 0=no)',
    creado_en                 timestamp                                                                          default CURRENT_TIMESTAMP null,
    actualizado_en            timestamp                                                                          default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint fk_serv_articulo
        foreign key (articulo_id) references articulo (id),
    constraint fk_serv_recur_articulo
        foreign key (articulo_id) references articulo (id),
    constraint servicios_recurrentes_creado_por_fk
        foreign key (creado_por) references usuarios (id),
    constraint servicios_recurrentes_socio_fk
        foreign key (socio_id) references socios_negocio (id),
    constraint servicios_recurrentes_usuario_fk
        foreign key (usuario_id) references usuarios (id)
)
    engine = InnoDB;

create table facturas_servicios_recurrentes
(
    id                     int auto_increment
        primary key,
    servicio_recurrente_id int                                                               not null comment 'Servicio recurrente origen',
    documento_id           bigint                                                            not null comment 'Factura generada',
    fecha_facturacion      date                                                              not null comment 'Fecha del período facturado',
    monto                  decimal(10, 2)                                                    not null comment 'Monto facturado',
    estado                 enum ('generated', 'paid', 'cancelled') default 'generated'       null comment 'Estado de la factura generada',
    generado_en            timestamp                               default CURRENT_TIMESTAMP null comment 'Cuándo se generó la factura',
    notas                  text                                                              null comment 'Notas adicionales',
    constraint facturas_servicios_recurrentes_documento_fk
        foreign key (documento_id) references documentos (id)
            on delete cascade,
    constraint facturas_servicios_recurrentes_servicio_fk
        foreign key (servicio_recurrente_id) references servicios_recurrentes (id)
            on delete cascade
)
    engine = InnoDB;

create table historial_servicios_recurrentes
(
    id                     int auto_increment
        primary key,
    servicio_recurrente_id int                                 not null,
    usuario_id             int                                 not null comment 'Usuario que realizó el cambio',
    accion                 varchar(50)                         not null comment 'CREATE, UPDATE, STATUS_CHANGE, DELETE, INVOICE_GENERATED',
    valores_anteriores     json                                null comment 'Valores anteriores',
    valores_nuevos         json                                null comment 'Valores nuevos',
    creado_en              timestamp default CURRENT_TIMESTAMP null,
    constraint historial_servicios_recurrentes_servicio_fk
        foreign key (servicio_recurrente_id) references servicios_recurrentes (id)
            on delete cascade,
    constraint historial_servicios_recurrentes_usuario_fk
        foreign key (usuario_id) references usuarios (id)
)
    engine = InnoDB;

create index idx_servicios_proxima
    on servicios_recurrentes (proxima_fecha_facturacion, estado);

create index idx_servicios_socio
    on servicios_recurrentes (socio_id);

create index idx_usuarios_empresa
    on usuarios (empresa_id);

create index idx_usuarios_rol
    on usuarios (rol_id);

-- MOdificacion de tabla transacciones para llevar el control de los movimientos

-- 1. Renombrar la tabla de transacciones_bancarias a transacciones
RENAME TABLE transacciones_bancarias TO transacciones;

-- 2. Eliminar la llave foránea y el índice de la columna cuenta_id
ALTER TABLE transacciones DROP FOREIGN KEY fk_transacciones_banco;
DROP INDEX idx_transacciones_cuenta ON transacciones;

-- 3. Eliminar la columna cuenta_id
ALTER TABLE transacciones DROP COLUMN cuenta_id;

-- 4. Agregar las nuevas columnas para relacionar con bancos y cajas
-- Se permiten nulos para que una transacción pueda ser de un Banco O de una Caja
ALTER TABLE transacciones
    ADD COLUMN banco_id INT NULL AFTER id,
    ADD COLUMN caja_id INT NULL AFTER banco_id;

-- 5. Crear las nuevas relaciones (Llaves Foráneas)
ALTER TABLE transacciones
    ADD CONSTRAINT fk_transacciones_bancos
    FOREIGN KEY (banco_id) REFERENCES contabilidad_bancos(id)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE transacciones
    ADD CONSTRAINT fk_transacciones_cajas
    FOREIGN KEY (caja_id) REFERENCES contabilidad_cajas(id)
    ON DELETE SET NULL ON UPDATE CASCADE;

-- 6. Crear índices para optimizar las búsquedas por banco o caja
CREATE INDEX idx_transacciones_banco ON transacciones(banco_id);
CREATE INDEX idx_transacciones_caja ON transacciones(caja_id);

--  Configuracion de la tabla metodo
-- 1. Crear la tabla de métodos de pago
CREATE TABLE transacciones_metodo_pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Insertar métodos iniciales comunes
INSERT INTO transacciones_metodo_pago (nombre, descripcion) VALUES
('Efectivo', 'Pago en efectivo o moneda local'),
('Transferencia Bancaria', 'Transferencia electrónica entre cuentas'),
('Tarjeta de Crédito/Débito', 'Pago mediante terminal punto de venta'),
('Cheque', 'Documentos bancarios nominativos');

-- 3. Modificar la tabla transacciones (antes transacciones_bancarias)
-- Se añade la nueva columna de relación
ALTER TABLE transacciones ADD COLUMN metodo_pago_id INT NULL AFTER caja_id;

-- 4. Crear la relación (Llave Foránea)
ALTER TABLE transacciones
    ADD CONSTRAINT fk_transacciones_metodo
    FOREIGN KEY (metodo_pago_id) REFERENCES transacciones_metodo_pago(id)
    ON DELETE SET NULL ON UPDATE CASCADE;

-- 5. Eliminar el campo 'metodo' antiguo (el que era un ENUM)
ALTER TABLE transacciones DROP COLUMN metodo;

-- 6. Crear índice para optimizar reportes por método de pago
CREATE INDEX idx_transacciones_metodo_pago ON transacciones(metodo_pago_id);

-- Para actualizar la tabla kardex_inventario

-- 1. Renombrar el campo stock_saldo a stock_total
ALTER TABLE kardex_inventario
    CHANGE COLUMN stock_saldo stock_total DECIMAL(10, 2) NOT NULL;

-- 2. Crear los campos stock_entrante y stock_saliente para un desglose claro por fila
-- Se añaden después de costo_unid para mantener un orden lógico (Movimiento -> Saldo)
ALTER TABLE kardex_inventario
    ADD COLUMN stock_entrante DECIMAL(10, 2) DEFAULT 0.00 AFTER costo_unid,
    ADD COLUMN stock_saliente DECIMAL(10, 2) DEFAULT 0.00 AFTER stock_entrante;

-- 3. Agregar la columna de relación con documentos.id
ALTER TABLE kardex_inventario
    ADD COLUMN documento_id INT NULL AFTER usuario_id;

-- 4. Crear la Llave Foránea para asegurar la integridad referencial
ALTER TABLE kardex_inventario
    ADD CONSTRAINT fk_kardex_documento
    FOREIGN KEY (documento_id) REFERENCES documentos(id)
    ON DELETE SET NULL ON UPDATE CASCADE;

-- 5. Crear un índice para optimizar las consultas de historial por documento
CREATE INDEX idx_kardex_documento ON kardex_inventario(documento_id);

-- Opcional: Si deseas migrar los datos actuales de 'cantidad' a las nuevas columnas
-- basado en el tipo de movimiento ya registrado:
UPDATE kardex_inventario SET stock_entrante = cantidad WHERE tipo = 'ENTRADA';
UPDATE kardex_inventario SET stock_saliente = cantidad WHERE tipo = 'SALIDA';

-- Actualizacion de tabla para crear tabla de confiramcion de publicacion

CREATE TABLE IF NOT EXISTS articulo_publicado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_articulo INT NOT NULL UNIQUE,
    publicado TINYINT(1) DEFAULT 0,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id) ON DELETE CASCADE
);

-- Implementacion de tabla para implemetar estado de presupuesto:
-- 1. Crear tabla de estados de presupuesto
CREATE TABLE IF NOT EXISTS `documentos_estado_presupuesto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `detalle` varchar(255) DEFAULT NULL,
  `color` varchar(20) DEFAULT '#64748b',
  `creado_en` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Insertar estados iniciales
INSERT INTO `documentos_estado_presupuesto` (`nombre`, `detalle`, `color`) VALUES
('Aprobado', 'Presupuesto aceptado por el cliente o proveedor', '#10b981'),
('Cancelado', 'Documento anulado o rechazado', '#ef4444'),
('Facturado', 'Presupuesto convertido en documento contable final', '#3b82f6'),
('En Revisión', 'Documento pendiente de confirmación o ajustes', '#f59e0b');

-- 3. Vincular con la tabla de documentos
ALTER TABLE `documentos` ADD COLUMN  `estado_presupuesto_id` INT(11) NULL after tipo_documento_id;
ALTER TABLE `documentos` ADD CONSTRAINT `fk_documento_estado_pre`
FOREIGN KEY (`estado_presupuesto_id`) REFERENCES `documentos_estado_presupuesto`(`id`)
ON DELETE SET NULL;
-- verificacionde cambios
