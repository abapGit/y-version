INTERFACE yif_abapgit_tag_popups
  PUBLIC.

  METHODS:
    tag_list_popup
      IMPORTING
        io_repo       TYPE REF TO ycl_abapgit_repo_online
      RETURNING
        VALUE(rs_tag) TYPE yif_abapgit_definitions=>ty_git_tag
      RAISING
        ycx_abapgit_exception,

    tag_select_popup
      IMPORTING
        io_repo       TYPE REF TO ycl_abapgit_repo_online
      RETURNING
        VALUE(rs_tag) TYPE yif_abapgit_definitions=>ty_git_tag
      RAISING
        ycx_abapgit_exception .

ENDINTERFACE.
