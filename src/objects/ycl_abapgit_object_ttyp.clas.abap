CLASS ycl_abapgit_object_ttyp DEFINITION PUBLIC INHERITING FROM ycl_abapgit_objects_super FINAL.

  PUBLIC SECTION.
    INTERFACES yif_abapgit_object.
    ALIASES mo_files FOR yif_abapgit_object~mo_files.

ENDCLASS.

CLASS ycl_abapgit_object_ttyp IMPLEMENTATION.

  METHOD yif_abapgit_object~has_changed_since.

    DATA: lv_date TYPE dats,
          lv_time TYPE tims.

    SELECT SINGLE as4date as4time FROM dd40l
      INTO (lv_date, lv_time)
      WHERE typename = ms_item-obj_name
      AND as4local = 'A'.

    rv_changed = check_timestamp(
      iv_timestamp = iv_timestamp
      iv_date      = lv_date
      iv_time      = lv_time ).

  ENDMETHOD.

  METHOD yif_abapgit_object~changed_by.

    SELECT SINGLE as4user FROM dd40l INTO rv_user
      WHERE typename = ms_item-obj_name
      AND as4local = 'A'.
    IF sy-subrc <> 0.
      rv_user = c_user_unknown.
    ENDIF.

  ENDMETHOD.

  METHOD yif_abapgit_object~get_metadata.
    rs_metadata = get_metadata( ).
    rs_metadata-ddic = abap_true.
  ENDMETHOD.

  METHOD yif_abapgit_object~exists.

    DATA: lv_typename TYPE dd40l-typename.


    SELECT SINGLE typename FROM dd40l INTO lv_typename
      WHERE typename = ms_item-obj_name
      AND as4local = 'A'.
    rv_bool = boolc( sy-subrc = 0 ).

  ENDMETHOD.

  METHOD yif_abapgit_object~jump.

    jump_se11( iv_radio = 'RSRD1-DDTYPE'
               iv_field = 'RSRD1-DDTYPE_VAL' ).

  ENDMETHOD.

  METHOD yif_abapgit_object~delete.

    DATA: lv_objname TYPE rsedd0-ddobjname.


    lv_objname = ms_item-obj_name.

    CALL FUNCTION 'RS_DD_DELETE_OBJ'
      EXPORTING
        no_ask               = abap_true
        objname              = lv_objname
        objtype              = 'A'
      EXCEPTIONS
        not_executed         = 1
        object_not_found     = 2
        object_not_specified = 3
        permission_failure   = 4.
    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( 'error from RS_DD_DELETE_OBJ, TTYP' ).
    ENDIF.

  ENDMETHOD.

  METHOD yif_abapgit_object~serialize.

    DATA: lv_name  TYPE ddobjname,
          lt_dd42v TYPE dd42v_tab,
          lt_dd43v TYPE dd43v_tab,
          ls_dd40v TYPE dd40v.


    lv_name = ms_item-obj_name.

    CALL FUNCTION 'DDIF_TTYP_GET'
      EXPORTING
        name          = lv_name
        state         = 'A'
        langu         = mv_language
      IMPORTING
        dd40v_wa      = ls_dd40v
      TABLES
        dd42v_tab     = lt_dd42v
        dd43v_tab     = lt_dd43v
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( 'error from DDIF_TTYP_GET' ).
    ENDIF.
    IF ls_dd40v IS INITIAL.
      RETURN. " does not exist in system
    ENDIF.

    CLEAR: ls_dd40v-as4user,
           ls_dd40v-as4date,
           ls_dd40v-as4time.

    IF NOT ls_dd40v-rowkind IS INITIAL.
      CLEAR ls_dd40v-typelen.
    ENDIF.

    io_xml->add( iv_name = 'DD40V'
                 ig_data = ls_dd40v ).
    io_xml->add( iv_name = 'DD42V'
                 ig_data = lt_dd42v ).
    io_xml->add( iv_name = 'DD43V'
                 ig_data = lt_dd43v ).

  ENDMETHOD.

  METHOD yif_abapgit_object~deserialize.

    DATA: lv_name  TYPE ddobjname,
          lt_dd42v TYPE dd42v_tab,
          lt_dd43v TYPE dd43v_tab,
          ls_dd40v TYPE dd40v.


    io_xml->read( EXPORTING iv_name = 'DD40V'
                  CHANGING cg_data = ls_dd40v ).
    io_xml->read( EXPORTING iv_name = 'DD42V'
                  CHANGING cg_data = lt_dd42v ).
    io_xml->read( EXPORTING iv_name = 'DD43V'
                  CHANGING cg_data = lt_dd43v ).

    corr_insert( iv_package ).

    lv_name = ms_item-obj_name. " type conversion

    CALL FUNCTION 'DDIF_TTYP_PUT'
      EXPORTING
        name              = lv_name
        dd40v_wa          = ls_dd40v
      TABLES
        dd42v_tab         = lt_dd42v
        dd43v_tab         = lt_dd43v
      EXCEPTIONS
        ttyp_not_found    = 1
        name_inconsistent = 2
        ttyp_inconsistent = 3
        put_failure       = 4
        put_refused       = 5
        OTHERS            = 6.
    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( 'error from DDIF_TTYP_PUT' ).
    ENDIF.

    ycl_abapgit_objects_activation=>add_item( ms_item ).

  ENDMETHOD.

  METHOD yif_abapgit_object~compare_to_remote_version.
    CREATE OBJECT ro_comparison_result TYPE ycl_abapgit_comparison_null.
  ENDMETHOD.

  METHOD yif_abapgit_object~is_locked.

    rv_is_locked = exists_a_lock_entry_for( iv_lock_object = 'ESDICT'
                                            iv_argument    = |{ ms_item-obj_type }{ ms_item-obj_name }| ).

  ENDMETHOD.

ENDCLASS.
