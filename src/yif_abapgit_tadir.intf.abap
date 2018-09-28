INTERFACE yif_abapgit_tadir
  PUBLIC .


  METHODS get_object_package
    IMPORTING
      !iv_pgmid          TYPE tadir-pgmid DEFAULT 'R3TR'
      !iv_object         TYPE tadir-object
      !iv_obj_name       TYPE tadir-obj_name
    RETURNING
      VALUE(rv_devclass) TYPE tadir-devclass
    RAISING
      ycx_abapgit_exception .
  METHODS read
    IMPORTING
      !iv_package            TYPE tadir-devclass
      !iv_ignore_subpackages TYPE abap_bool DEFAULT abap_false
      !iv_only_local_objects TYPE abap_bool DEFAULT abap_false
      !io_dot                TYPE REF TO ycl_abapgit_dot_abapgit OPTIONAL
      !io_log                TYPE REF TO ycl_abapgit_log OPTIONAL
    RETURNING
      VALUE(rt_tadir)        TYPE yif_abapgit_definitions=>ty_tadir_tt
    RAISING
      ycx_abapgit_exception .
  METHODS read_single
    IMPORTING
      !iv_pgmid       TYPE tadir-pgmid DEFAULT 'R3TR'
      !iv_object      TYPE tadir-object
      !iv_obj_name    TYPE tadir-obj_name
    RETURNING
      VALUE(rs_tadir) TYPE yif_abapgit_definitions=>ty_tadir
    RAISING
      ycx_abapgit_exception .
ENDINTERFACE.
