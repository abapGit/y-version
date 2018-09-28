INTERFACE yif_abapgit_stage_logic
  PUBLIC .

  METHODS get
    IMPORTING
      !io_repo        TYPE REF TO ycl_abapgit_repo_online
    RETURNING
      VALUE(rs_files) TYPE yif_abapgit_definitions=>ty_stage_files
    RAISING
      ycx_abapgit_exception .

ENDINTERFACE.
