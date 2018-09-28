INTERFACE yif_abapgit_object PUBLIC.

  METHODS:
    serialize
      IMPORTING io_xml TYPE REF TO ycl_abapgit_xml_output
      RAISING   ycx_abapgit_exception,
    deserialize
      IMPORTING iv_package TYPE devclass
                io_xml     TYPE REF TO ycl_abapgit_xml_input
      RAISING   ycx_abapgit_exception,
    delete
      RAISING ycx_abapgit_exception,
    exists
      RETURNING VALUE(rv_bool) TYPE abap_bool
      RAISING   ycx_abapgit_exception,
    is_locked
      RETURNING VALUE(rv_is_locked) type abap_bool
      RAISING
        ycx_abapgit_exception,
    changed_by
      RETURNING VALUE(rv_user) TYPE xubname
      RAISING   ycx_abapgit_exception,
    jump
      RAISING ycx_abapgit_exception,
    get_metadata
      RETURNING VALUE(rs_metadata) TYPE yif_abapgit_definitions=>ty_metadata,
    has_changed_since
      IMPORTING iv_timestamp      TYPE timestamp
      RETURNING VALUE(rv_changed) TYPE abap_bool
      RAISING   ycx_abapgit_exception.
  METHODS:
    compare_to_remote_version
      IMPORTING io_remote_version_xml       TYPE REF TO ycl_abapgit_xml_input
      RETURNING VALUE(ro_comparison_result) TYPE REF TO yif_abapgit_comparison_result
      RAISING   ycx_abapgit_exception.

  DATA: mo_files TYPE REF TO ycl_abapgit_objects_files.

ENDINTERFACE.
