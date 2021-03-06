CLASS ycl_abapgit_proxy_config DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      constructor,

      get_proxy_url
        IMPORTING
          iv_repo_url         TYPE csequence OPTIONAL
        RETURNING
          VALUE(rv_proxy_url) TYPE string,

      get_proxy_port
        IMPORTING
          iv_repo_url    TYPE csequence OPTIONAL
        RETURNING
          VALUE(rv_port) TYPE string,

      get_proxy_authentication
        IMPORTING
          iv_repo_url    TYPE csequence OPTIONAL
        RETURNING
          VALUE(rv_auth) TYPE abap_bool.

  PRIVATE SECTION.
    DATA: mo_settings TYPE REF TO ycl_abapgit_settings,
          mi_exit     TYPE REF TO yif_abapgit_exit.

ENDCLASS.



CLASS YCL_ABAPGIT_PROXY_CONFIG IMPLEMENTATION.


  METHOD constructor.

    mo_settings = ycl_abapgit_persist_settings=>get_instance( )->read( ).

    mi_exit = ycl_abapgit_exit=>get_instance( ).

  ENDMETHOD.


  METHOD get_proxy_authentication.

    rv_auth = mo_settings->get_proxy_authentication( ).

    mi_exit->change_proxy_authentication(
      EXPORTING
        iv_repo_url            = iv_repo_url
      CHANGING
        cv_proxy_authentication = rv_auth ).

  ENDMETHOD.


  METHOD get_proxy_port.

    rv_port = mo_settings->get_proxy_port( ).

    mi_exit->change_proxy_port(
      EXPORTING
        iv_repo_url  = iv_repo_url
      CHANGING
        cv_proxy_port = rv_port ).

  ENDMETHOD.


  METHOD get_proxy_url.

    rv_proxy_url = mo_settings->get_proxy_url( ).

    mi_exit->change_proxy_url(
      EXPORTING
        iv_repo_url = iv_repo_url
      CHANGING
        cv_proxy_url = rv_proxy_url ).

  ENDMETHOD.
ENDCLASS.
