CLASS ycl_abapgit_stage_logic DEFINITION
  PUBLIC
  CREATE PRIVATE

  GLOBAL FRIENDS ycl_abapgit_factory .

  PUBLIC SECTION.

    INTERFACES yif_abapgit_stage_logic .
  PRIVATE SECTION.
    CLASS-METHODS:
      remove_ignored
        IMPORTING io_repo  TYPE REF TO ycl_abapgit_repo_online
        CHANGING  cs_files TYPE yif_abapgit_definitions=>ty_stage_files,
      remove_identical
        CHANGING cs_files TYPE yif_abapgit_definitions=>ty_stage_files.

ENDCLASS.



CLASS YCL_ABAPGIT_STAGE_LOGIC IMPLEMENTATION.


  METHOD remove_identical.

    DATA: lv_index  TYPE i,
          ls_remote LIKE LINE OF cs_files-remote.

    FIELD-SYMBOLS: <ls_local> LIKE LINE OF cs_files-local.

    SORT cs_files-remote BY path filename.

    LOOP AT cs_files-local ASSIGNING <ls_local>.
      lv_index = sy-tabix.

      READ TABLE cs_files-remote INTO ls_remote
        WITH KEY path = <ls_local>-file-path filename = <ls_local>-file-filename
        BINARY SEARCH.
      IF sy-subrc = 0.
        DELETE cs_files-remote INDEX sy-tabix.
        IF ls_remote-sha1 = <ls_local>-file-sha1.
          DELETE cs_files-local INDEX lv_index.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD remove_ignored.

    DATA: lv_index TYPE i.

    FIELD-SYMBOLS: <ls_remote> LIKE LINE OF cs_files-remote.


    LOOP AT cs_files-remote ASSIGNING <ls_remote>.
      lv_index = sy-tabix.

      IF io_repo->get_dot_abapgit( )->is_ignored(
          iv_path     = <ls_remote>-path
          iv_filename = <ls_remote>-filename ) = abap_true.
        DELETE cs_files-remote INDEX lv_index.
      ELSEIF <ls_remote>-path     = yif_abapgit_definitions=>c_root_dir
         AND <ls_remote>-filename = yif_abapgit_definitions=>c_dot_abapgit.
        " Remove .abapgit from remotes - it cannot be removed or ignored
        DELETE cs_files-remote INDEX lv_index.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD yif_abapgit_stage_logic~get.

    rs_files-local  = io_repo->get_files_local( ).
    rs_files-remote = io_repo->get_files_remote( ).
    remove_identical( CHANGING cs_files = rs_files ).
    remove_ignored( EXPORTING io_repo  = io_repo
                    CHANGING  cs_files = rs_files ).

  ENDMETHOD.
ENDCLASS.
