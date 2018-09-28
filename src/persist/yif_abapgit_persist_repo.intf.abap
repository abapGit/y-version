INTERFACE yif_abapgit_persist_repo
  PUBLIC .


  METHODS add
    IMPORTING
      !iv_url         TYPE string
      !iv_branch_name TYPE string
      !iv_branch      TYPE yif_abapgit_definitions=>ty_sha1 OPTIONAL
      !iv_package     TYPE devclass
      !iv_offline     TYPE sap_bool DEFAULT abap_false
      !is_dot_abapgit TYPE yif_abapgit_dot_abapgit=>ty_dot_abapgit
    RETURNING
      VALUE(rv_key)   TYPE yif_abapgit_persistence=>ty_repo-key
    RAISING
      ycx_abapgit_exception .
  METHODS delete
    IMPORTING
      !iv_key TYPE yif_abapgit_persistence=>ty_repo-key
    RAISING
      ycx_abapgit_exception .
  METHODS list
    RETURNING
      VALUE(rt_repos) TYPE yif_abapgit_persistence=>tt_repo
    RAISING
      ycx_abapgit_exception .
  METHODS lock
    IMPORTING
      !iv_mode TYPE enqmode
      !iv_key  TYPE yif_abapgit_persistence=>ty_repo-key
    RAISING
      ycx_abapgit_exception .
  METHODS read
    IMPORTING
      !iv_key        TYPE yif_abapgit_persistence=>ty_repo-key
    RETURNING
      VALUE(rs_repo) TYPE yif_abapgit_persistence=>ty_repo
    RAISING
      ycx_abapgit_exception
      ycx_abapgit_not_found .
  METHODS update_branch_name
    IMPORTING
      !iv_key         TYPE yif_abapgit_persistence=>ty_repo-key
      !iv_branch_name TYPE yif_abapgit_persistence=>ty_repo_xml-branch_name
    RAISING
      ycx_abapgit_exception .
  METHODS update_deserialized
    IMPORTING
      !iv_key             TYPE yif_abapgit_persistence=>ty_value
      !iv_deserialized_at TYPE timestampl
      !iv_deserialized_by TYPE xubname
    RAISING
      ycx_abapgit_exception .
  METHODS update_dot_abapgit
    IMPORTING
      !iv_key         TYPE yif_abapgit_persistence=>ty_repo-key
      !is_dot_abapgit TYPE yif_abapgit_dot_abapgit=>ty_dot_abapgit
    RAISING
      ycx_abapgit_exception .
  METHODS update_head_branch
    IMPORTING
      !iv_key         TYPE yif_abapgit_persistence=>ty_repo-key
      !iv_head_branch TYPE yif_abapgit_persistence=>ty_repo_xml-head_branch
    RAISING
      ycx_abapgit_exception .
  METHODS update_local_checksums
    IMPORTING
      !iv_key       TYPE yif_abapgit_persistence=>ty_repo-key
      !it_checksums TYPE yif_abapgit_persistence=>ty_repo_xml-local_checksums
    RAISING
      ycx_abapgit_exception .
  METHODS update_local_settings
    IMPORTING
      !iv_key      TYPE yif_abapgit_persistence=>ty_repo-key
      !is_settings TYPE yif_abapgit_persistence=>ty_repo_xml-local_settings
    RAISING
      ycx_abapgit_exception .
  METHODS update_offline
    IMPORTING
      !iv_key     TYPE yif_abapgit_persistence=>ty_repo-key
      !iv_offline TYPE yif_abapgit_persistence=>ty_repo_xml-offline
    RAISING
      ycx_abapgit_exception .
  METHODS update_url
    IMPORTING
      !iv_key TYPE yif_abapgit_persistence=>ty_repo-key
      !iv_url TYPE yif_abapgit_persistence=>ty_repo_xml-url
    RAISING
      ycx_abapgit_exception .
ENDINTERFACE.
