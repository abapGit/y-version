CLASS ycl_abapgit_object_suso DEFINITION PUBLIC INHERITING FROM ycl_abapgit_objects_super FINAL.

  PUBLIC SECTION.
    INTERFACES yif_abapgit_object.
    ALIASES mo_files FOR yif_abapgit_object~mo_files.

    METHODS:
      constructor
        IMPORTING
          is_item     TYPE yif_abapgit_definitions=>ty_item
          iv_language TYPE spras.

  PRIVATE SECTION.
    DATA:
      mv_objectname TYPE tobj-objct.

    METHODS:
      delete_documentation
        RAISING
          ycx_abapgit_exception.

ENDCLASS.

CLASS ycl_abapgit_object_suso IMPLEMENTATION.

  METHOD constructor.

    super->constructor( is_item     = is_item
                        iv_language = iv_language ).

    mv_objectname = ms_item-obj_name.

  ENDMETHOD.

  METHOD yif_abapgit_object~has_changed_since.
    rv_changed = abap_true.
  ENDMETHOD.

  METHOD yif_abapgit_object~changed_by.
    rv_user = c_user_unknown. " todo
  ENDMETHOD.

  METHOD yif_abapgit_object~get_metadata.
    rs_metadata = get_metadata( ).
  ENDMETHOD.

  METHOD yif_abapgit_object~exists.

    DATA: lv_objct TYPE tobj-objct.


    SELECT SINGLE objct FROM tobj INTO lv_objct
      WHERE objct = ms_item-obj_name.
    rv_bool = boolc( sy-subrc = 0 ).

  ENDMETHOD.

  METHOD yif_abapgit_object~serialize.

    DATA: ls_tobj       TYPE tobj,
          ls_tobjt      TYPE tobjt,
          ls_tobjvorflg TYPE tobjvorflg,
          lt_tactz      TYPE TABLE OF tactz,
          lt_tobjvordat TYPE TABLE OF tobjvordat,
          lt_tobjvor    TYPE TABLE OF tobjvor.


    SELECT SINGLE * FROM tobj INTO ls_tobj
      WHERE objct = ms_item-obj_name.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    CLEAR ls_tobj-bname.

    SELECT SINGLE * FROM tobjt INTO ls_tobjt
      WHERE object = ms_item-obj_name
      AND langu = mv_language.                          "#EC CI_GENBUFF
    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( 'TOBJT no english description'
        && ' for object (' && ms_item-obj_name && ')' ).
    ENDIF.

    SELECT SINGLE * FROM tobjvorflg INTO ls_tobjvorflg
      WHERE objct = ms_item-obj_name.                     "#EC CI_SUBRC

    SELECT * FROM tactz INTO TABLE lt_tactz
      WHERE brobj = ms_item-obj_name
      ORDER BY PRIMARY KEY.               "#EC CI_SUBRC "#EC CI_GENBUFF

    SELECT * FROM tobjvordat INTO TABLE lt_tobjvordat
      WHERE objct = ms_item-obj_name
      ORDER BY PRIMARY KEY.               "#EC CI_SUBRC "#EC CI_GENBUFF

    SELECT * FROM tobjvor INTO TABLE lt_tobjvor
      WHERE objct = ms_item-obj_name
      ORDER BY PRIMARY KEY.                               "#EC CI_SUBRC

    io_xml->add( iv_name = 'TOBJ'
                 ig_data = ls_tobj ).
    io_xml->add( iv_name = 'TOBJT'
                 ig_data = ls_tobjt ).
    io_xml->add( iv_name = 'TOBJVORFLG'
                 ig_data = ls_tobjvorflg ).
    io_xml->add( ig_data = lt_tactz
                 iv_name = 'TACTZ' ).
    io_xml->add( ig_data = lt_tobjvordat
                 iv_name = 'TOBJVORDAT' ).
    io_xml->add( ig_data = lt_tobjvor
                 iv_name = 'TOBJVOR' ).

  ENDMETHOD.

  METHOD yif_abapgit_object~deserialize.
* see function group SUSA

    DATA: lv_objectname TYPE trobj_name,
          ls_tobj       TYPE tobj,
          ls_tobjt      TYPE tobjt,
          ls_tobjvorflg TYPE tobjvorflg,
          lt_tactz      TYPE TABLE OF tactz,
          lt_tobjvordat TYPE TABLE OF tobjvordat,
          lt_tobjvor    TYPE TABLE OF tobjvor.


    ASSERT NOT ms_item-obj_name IS INITIAL.

    io_xml->read( EXPORTING iv_name = 'TOBJ'
                  CHANGING cg_data = ls_tobj ).
    ls_tobj-bname = sy-uname.
    io_xml->read( EXPORTING iv_name = 'TOBJT'
                  CHANGING cg_data = ls_tobjt ).
    io_xml->read( EXPORTING iv_name = 'TOBJVORFLG'
                  CHANGING cg_data = ls_tobjvorflg ).
    io_xml->read( EXPORTING iv_name = 'TACTZ'
                  CHANGING  cg_data = lt_tactz ).
    io_xml->read( EXPORTING iv_name = 'TOBJVORDAT'
                  CHANGING  cg_data = lt_tobjvordat ).
    io_xml->read( EXPORTING iv_name = 'TOBJVOR'
                  CHANGING  cg_data = lt_tobjvor ).

    tadir_insert( iv_package ).

    lv_objectname = mv_objectname.

    CALL FUNCTION 'SUSR_COMMEDITCHECK'
      EXPORTING
        objectname      = lv_objectname
        transobjecttype = 'O'.

    MODIFY tobj FROM ls_tobj.                             "#EC CI_SUBRC
    MODIFY tobjt FROM ls_tobjt.                           "#EC CI_SUBRC
    MODIFY tobjvorflg FROM ls_tobjvorflg.                 "#EC CI_SUBRC
    DELETE FROM tactz WHERE brobj = ms_item-obj_name.     "#EC CI_SUBRC
    INSERT tactz FROM TABLE lt_tactz.                     "#EC CI_SUBRC
    DELETE FROM tobjvordat WHERE objct = ms_item-obj_name. "#EC CI_SUBRC
    INSERT tobjvordat FROM TABLE lt_tobjvordat.           "#EC CI_SUBRC
    DELETE FROM tobjvor WHERE objct = ms_item-obj_name.   "#EC CI_SUBRC
    INSERT tobjvor FROM TABLE lt_tobjvor.                 "#EC CI_SUBRC

  ENDMETHOD.

  METHOD yif_abapgit_object~delete.

    " FM SUSR_DELETE_OBJECT calls the UI. Therefore we reimplement it here.

    CONSTANTS:
      co_act_delete TYPE activ_auth VALUE '06'.

    DATA:
      lv_act_head            TYPE activ_auth,
      lv_dummy               TYPE string,
      lo_suso                TYPE REF TO object,
      lv_failed              TYPE abap_bool,
      lv_suso_collect_in_cts TYPE i.

    " Downport: CL_SUSO_GEN doesn't exist in 702
    CREATE OBJECT lo_suso
      TYPE
        ('CL_SUSO_GEN').

    CALL METHOD lo_suso->('SUSO_LOAD_FROM_DB')
      EXPORTING
        id_object = mv_objectname
      RECEIVING
        ed_failed = lv_failed.

    IF lv_failed = abap_true.
      " Object & does not exist; choose an existing object
      MESSAGE s111(01) WITH mv_objectname INTO lv_dummy.
      ycx_abapgit_exception=>raise_t100( ).
    ENDIF.

    CALL METHOD lo_suso->('GET_SUSO_EDIT_MODE')
      EXPORTING
        id_object     = mv_objectname
        id_planed_act = co_act_delete
      IMPORTING
        ed_mode_head  = lv_act_head.

    IF lv_act_head <> co_act_delete.
      ycx_abapgit_exception=>raise( |AUTH { mv_objectname }: Delete not allowed| ).
    ENDIF.

    CALL METHOD lo_suso->('SUSO_COLLECT_IN_CTS')
      EXPORTING
        id_object = mv_objectname
      RECEIVING
        ed_result = lv_suso_collect_in_cts.

    IF lv_suso_collect_in_cts IS NOT INITIAL.
      RETURN.
    ENDIF.

    delete_documentation( ).

    DELETE FROM tobj  WHERE objct  = mv_objectname.
    DELETE FROM tobjt WHERE object = mv_objectname.
    DELETE FROM tactz WHERE brobj  = mv_objectname.

    CALL FUNCTION 'SUPV_DELETE_OBJECT_ASSIGNMENTS'
      EXPORTING
        object_name  = mv_objectname
        all_releases = abap_true.

    CALL FUNCTION 'RS_TREE_OBJECT_PLACEMENT'
      EXPORTING
        object    = mv_objectname
        type      = 'SUSO'
        operation = 'DELETE'.

  ENDMETHOD.

  METHOD delete_documentation.

    DATA:
      lv_docu_obj TYPE dokhl-object,
      lv_dummy    TYPE sy-langu.

    lv_docu_obj  = mv_objectname.

    SELECT SINGLE langu
           FROM dokil INTO lv_dummy
           WHERE id   = 'UO'                            "#EC CI_GENBUFF
           AND object = lv_docu_obj.

    IF sy-subrc = 0.

      CALL FUNCTION 'DOKU_DELETE_ALL'
        EXPORTING
          doku_id                        = 'UO'
          doku_object                    = lv_docu_obj
          suppress_transport             = space
        EXCEPTIONS
          header_without_text            = 1
          index_without_header           = 2
          no_authority_for_devclass_xxxx = 3
          no_docu_found                  = 4
          object_is_already_enqueued     = 5
          object_is_enqueued_by_corr     = 6
          techn_enqueue_problem          = 7
          user_break                     = 8
          OTHERS                         = 9.

      IF sy-subrc <> 0.
        ycx_abapgit_exception=>raise_t100( ).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD yif_abapgit_object~jump.

    CALL FUNCTION 'SUSR_SHOW_OBJECT'
      EXPORTING
        object = mv_objectname.

  ENDMETHOD.

  METHOD yif_abapgit_object~compare_to_remote_version.
    CREATE OBJECT ro_comparison_result TYPE ycl_abapgit_comparison_null.
  ENDMETHOD.

  METHOD yif_abapgit_object~is_locked.

    rv_is_locked = abap_false.

  ENDMETHOD.

ENDCLASS.