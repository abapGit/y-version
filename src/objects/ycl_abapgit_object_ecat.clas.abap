CLASS ycl_abapgit_object_ecat DEFINITION
  PUBLIC
  INHERITING FROM ycl_abapgit_object_ecatt_super
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          !is_item     TYPE yif_abapgit_definitions=>ty_item
          !iv_language TYPE spras.

  PROTECTED SECTION.
    METHODS:
      get_object_type REDEFINITION,
      get_upload REDEFINITION,
      get_download REDEFINITION,
      get_lock_object REDEFINITION.

ENDCLASS.



CLASS ycl_abapgit_object_ecat IMPLEMENTATION.


  METHOD constructor.

    super->constructor( is_item     = is_item
                        iv_language = iv_language ).

  ENDMETHOD.


  METHOD get_object_type.

    rv_object_type = cl_apl_ecatt_const=>obj_type_test_script.

  ENDMETHOD.

  METHOD get_upload.

    CREATE OBJECT ro_upload TYPE ycl_abapgit_ecatt_script_upl.

  ENDMETHOD.

  METHOD get_download.

    CREATE OBJECT ro_download TYPE ycl_abapgit_ecatt_script_downl.

  ENDMETHOD.

  METHOD get_lock_object.

    rv_lock_object = 'E_ECATT'.

  ENDMETHOD.

ENDCLASS.
