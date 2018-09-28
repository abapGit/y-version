CLASS ycl_abapgit_git_add_patch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          it_diff TYPE yif_abapgit_definitions=>ty_diffs_tt,

      get_patch
        RETURNING
          VALUE(rt_patch) TYPE stringtab
        RAISING
          ycx_abapgit_exception,

      get_patch_binary
        RETURNING
          VALUE(rv_patch_binary) TYPE xstring
        RAISING
          ycx_abapgit_exception.

  PRIVATE SECTION.
    DATA:
      mt_diff  TYPE yif_abapgit_definitions=>ty_diffs_tt,
      mt_patch TYPE stringtab.

    METHODS:
      calculate_patch
        RETURNING
          VALUE(rt_patch) TYPE stringtab
        RAISING
          ycx_abapgit_exception.

ENDCLASS.



CLASS ycl_abapgit_git_add_patch IMPLEMENTATION.


  METHOD calculate_patch.

    FIELD-SYMBOLS: <ls_diff> TYPE yif_abapgit_definitions=>ty_diff.

    LOOP AT mt_diff ASSIGNING <ls_diff>.

      CASE <ls_diff>-result.
        WHEN ' '.

          INSERT <ls_diff>-new INTO TABLE rt_patch.

        WHEN yif_abapgit_definitions=>c_diff-insert.

          IF <ls_diff>-patch_flag = abap_true.
            INSERT <ls_diff>-new INTO TABLE rt_patch.
          ENDIF.

        WHEN yif_abapgit_definitions=>c_diff-delete.

          IF <ls_diff>-patch_flag = abap_false.
            INSERT <ls_diff>-old INTO TABLE rt_patch.
          ENDIF.

        WHEN yif_abapgit_definitions=>c_diff-update.

          IF <ls_diff>-patch_flag = abap_true.
            INSERT <ls_diff>-new INTO TABLE rt_patch.
          ELSE.
            INSERT <ls_diff>-old INTO TABLE rt_patch.
          ENDIF.

        WHEN OTHERS.

          ycx_abapgit_exception=>raise( |Unknown result| ).

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    mt_diff = it_diff.

  ENDMETHOD.


  METHOD get_patch.

    IF mt_patch IS INITIAL.
      mt_patch = calculate_patch( ).
    ENDIF.

    rt_patch = mt_patch.

  ENDMETHOD.


  METHOD get_patch_binary.

    DATA: lv_string TYPE string.

    IF mt_patch IS INITIAL.
      mt_patch = calculate_patch( ).
    ENDIF.

    CONCATENATE LINES OF mt_patch INTO lv_string SEPARATED BY yif_abapgit_definitions=>c_newline.
    lv_string = lv_string && yif_abapgit_definitions=>c_newline.

    rv_patch_binary = ycl_abapgit_convert=>string_to_xstring_utf8( lv_string ).

  ENDMETHOD.
ENDCLASS.
