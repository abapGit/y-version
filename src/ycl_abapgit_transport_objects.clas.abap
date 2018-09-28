CLASS ycl_abapgit_transport_objects DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !it_transport_objects TYPE yif_abapgit_definitions=>ty_tadir_tt .
    METHODS to_stage
      IMPORTING
        !io_stage           TYPE REF TO ycl_abapgit_stage
        !is_stage_objects   TYPE yif_abapgit_definitions=>ty_stage_files
        !it_object_statuses TYPE yif_abapgit_definitions=>ty_results_tt
      RAISING
        ycx_abapgit_exception .
  PRIVATE SECTION.

    DATA mt_transport_objects TYPE yif_abapgit_definitions=>ty_tadir_tt .
ENDCLASS.



CLASS YCL_ABAPGIT_TRANSPORT_OBJECTS IMPLEMENTATION.


  METHOD constructor.
    mt_transport_objects = it_transport_objects.
  ENDMETHOD.


  METHOD to_stage.
    DATA: ls_transport_object LIKE LINE OF mt_transport_objects,
          ls_local_file       TYPE yif_abapgit_definitions=>ty_file_item,
          ls_object_status    TYPE yif_abapgit_definitions=>ty_result.

    LOOP AT mt_transport_objects INTO ls_transport_object.
      LOOP AT it_object_statuses INTO ls_object_status
          WHERE obj_name = ls_transport_object-obj_name
          AND obj_type = ls_transport_object-object
          AND NOT lstate IS INITIAL.

        CASE ls_object_status-lstate.
          WHEN yif_abapgit_definitions=>c_state-added OR yif_abapgit_definitions=>c_state-modified.
            IF ls_transport_object-delflag = abap_true.
              ycx_abapgit_exception=>raise( |Object { ls_transport_object-obj_name
              } should be added/modified, but has deletion flag in transport| ).
            ENDIF.

            READ TABLE is_stage_objects-local
                  INTO ls_local_file
              WITH KEY item-obj_name = ls_transport_object-obj_name
                       item-obj_type = ls_transport_object-object
                       file-filename = ls_object_status-filename.
            IF sy-subrc <> 0.
              ycx_abapgit_exception=>raise( |Object { ls_transport_object-obj_name
              } not found in the local repository files| ).
            ENDIF.

            io_stage->add(
              iv_path     = ls_local_file-file-path
              iv_filename = ls_local_file-file-filename
              iv_data     = ls_local_file-file-data ).
          WHEN yif_abapgit_definitions=>c_state-deleted.
            IF ls_transport_object-delflag = abap_false.
              ycx_abapgit_exception=>raise( |Object { ls_transport_object-obj_name
              } should be removed, but has NO deletion flag in transport| ).
            ENDIF.
            io_stage->rm(
              iv_path     = ls_object_status-path
              iv_filename = ls_object_status-filename ).
          WHEN OTHERS.
            ASSERT 0 = 1. "Unexpected state
        ENDCASE.
      ENDLOOP.
      IF sy-subrc <> 0.
        ycx_abapgit_exception=>raise( |Object { ls_transport_object-obj_name
        } not found in the local repository files| ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
