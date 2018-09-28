CLASS ycl_abapgit_background_pull DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES yif_abapgit_background .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_ABAPGIT_BACKGROUND_PULL IMPLEMENTATION.


  METHOD yif_abapgit_background~get_description.

    rv_description = 'Automatic pull' ##NO_TEXT.

  ENDMETHOD.


  METHOD yif_abapgit_background~get_settings.
    RETURN.
  ENDMETHOD.


  METHOD yif_abapgit_background~run.

    DATA: ls_checks TYPE yif_abapgit_definitions=>ty_deserialize_checks.


* todo, set defaults in ls_checks
    io_repo->deserialize( ls_checks ).

  ENDMETHOD.
ENDCLASS.
