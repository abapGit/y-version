INTERFACE yif_abapgit_git_operations
  PUBLIC .

  METHODS push
    IMPORTING
      !is_comment TYPE yif_abapgit_definitions=>ty_comment
      !io_stage   TYPE REF TO ycl_abapgit_stage
    RAISING
      ycx_abapgit_exception .

  METHODS create_branch
    IMPORTING
      !iv_name TYPE string
      !iv_from TYPE yif_abapgit_definitions=>ty_sha1 OPTIONAL
    RAISING
      ycx_abapgit_exception .

ENDINTERFACE.
