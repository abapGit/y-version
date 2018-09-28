INTERFACE yif_abapgit_repo_srv
  PUBLIC .


  METHODS delete
    IMPORTING
      !io_repo TYPE REF TO ycl_abapgit_repo
    RAISING
      ycx_abapgit_exception .
  METHODS get
    IMPORTING
      !iv_key        TYPE yif_abapgit_persistence=>ty_value
    RETURNING
      VALUE(ro_repo) TYPE REF TO ycl_abapgit_repo
    RAISING
      ycx_abapgit_exception .
  METHODS is_repo_installed
    IMPORTING
      !iv_url             TYPE string
      !iv_target_package  TYPE devclass OPTIONAL
    RETURNING
      VALUE(rv_installed) TYPE abap_bool
    RAISING
      ycx_abapgit_exception .
  METHODS list
    RETURNING
      VALUE(rt_list) TYPE yif_abapgit_definitions=>ty_repo_ref_tt
    RAISING
      ycx_abapgit_exception .
  METHODS new_offline
    IMPORTING
      !iv_url        TYPE string
      !iv_package    TYPE devclass
    RETURNING
      VALUE(ro_repo) TYPE REF TO ycl_abapgit_repo_offline
    RAISING
      ycx_abapgit_exception .
  METHODS new_online
    IMPORTING
      !iv_url         TYPE string
      !iv_branch_name TYPE string
      !iv_package     TYPE devclass
    RETURNING
      VALUE(ro_repo)  TYPE REF TO ycl_abapgit_repo_online
    RAISING
      ycx_abapgit_exception .
  METHODS purge
    IMPORTING
      !io_repo  TYPE REF TO ycl_abapgit_repo
      is_checks TYPE yif_abapgit_definitions=>ty_delete_checks
    RAISING
      ycx_abapgit_exception .
  METHODS switch_repo_type
    IMPORTING
      !iv_key     TYPE yif_abapgit_persistence=>ty_value
      !iv_offline TYPE abap_bool
    RAISING
      ycx_abapgit_exception .
  METHODS validate_package
    IMPORTING
      !iv_package TYPE devclass
    RAISING
      ycx_abapgit_exception .
ENDINTERFACE.
