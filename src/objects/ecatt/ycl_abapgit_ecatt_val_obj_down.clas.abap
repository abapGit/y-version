CLASS ycl_abapgit_ecatt_val_obj_down DEFINITION
  PUBLIC
  INHERITING FROM cl_apl_ecatt_download
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      download REDEFINITION,

      get_xml_stream
        RETURNING
          VALUE(rv_xml_stream) TYPE xstring,

      get_xml_stream_size
        RETURNING
          VALUE(rv_xml_stream_size) TYPE int4.

  PROTECTED SECTION.
    DATA:
      li_objects_node TYPE REF TO if_ixml_element.

    METHODS:
      download_data REDEFINITION.

  PRIVATE SECTION.
    DATA:
      mv_xml_stream      TYPE xstring,
      mv_xml_stream_size TYPE int4.

    METHODS:
      set_ecatt_impl_detail,
      set_ecatt_flags,
      set_business_msgs.

ENDCLASS.



CLASS ycl_abapgit_ecatt_val_obj_down IMPLEMENTATION.


  METHOD download.

    " We inherit from CL_APL_ECATT_DOWNLOAD because CL_APL_ECATT_VO_DOWNLOAD
    " doesn't exist in 702

    " Downport

    DATA: lv_partyp   TYPE string,
          lo_ecatt_vo TYPE REF TO object.

    FIELD-SYMBOLS: <lg_ecatt_vo> TYPE any,
                   <lt_params>   TYPE REF TO cl_apl_ecatt_params.

    load_help = im_load_help.
    typ = im_object_type.

    TRY.
        cl_apl_ecatt_object=>show_object(
          EXPORTING
            im_obj_type = im_object_type
            im_name     = im_object_name
            im_version  = im_object_version
          IMPORTING
            re_object   = ecatt_object ).
      CATCH cx_ecatt INTO ex_ecatt.
        RETURN.
    ENDTRY.

    lv_partyp = cl_apl_ecatt_const=>params_type_par.


    ASSIGN ('ECATT_OBJECT') TO <lg_ecatt_vo>.
    ASSERT sy-subrc = 0.

    lo_ecatt_vo = <lg_ecatt_vo>.

    set_attributes_to_template( ).
    set_ecatt_impl_detail( ).
    set_ecatt_flags( ).
    set_business_msgs( ).

    ASSIGN lo_ecatt_vo->('PARAMS')
           TO <lt_params>.
    ASSERT sy-subrc = 0.

    get_general_params_data( im_params = <lt_params>
                             im_ptyp   = lv_partyp ).
    LOOP AT parm INTO wa_parm.
      set_general_params_data_to_dom( ).
      IF NOT wa_parm-val_type IS INITIAL.
        set_deep_stru_to_dom( <lt_params> ).
        set_deep_data_to_dom( im_params = <lt_params>
                              im_pindex = wa_parm-pindex ).
      ENDIF.
    ENDLOOP.

    set_variants_to_dom( <lt_params> ).

    download_data( ).

  ENDMETHOD.


  METHOD download_data.

    " Downport

    ycl_abapgit_ecatt_helper=>download_data(
      EXPORTING
        ii_template_over_all = template_over_all
      IMPORTING
        ev_xml_stream        = mv_xml_stream
        ev_xml_stream_size   = mv_xml_stream_size ).

  ENDMETHOD.


  METHOD get_xml_stream.

    rv_xml_stream = mv_xml_stream.

  ENDMETHOD.


  METHOD get_xml_stream_size.

    rv_xml_stream_size = mv_xml_stream_size.

  ENDMETHOD.


  METHOD set_business_msgs.

    DATA:
      lt_buss_msg_ref   TYPE yif_abapgit_ecatt=>etvo_bus_msg_tabtype,
      li_element        TYPE REF TO if_ixml_element,
      li_insert_objects TYPE REF TO if_ixml_element,
      lo_ecatt_vo       TYPE REF TO object.

    FIELD-SYMBOLS: <lg_ecatt_vo> TYPE any.

    ASSIGN ('ECATT_OBJECT') TO <lg_ecatt_vo>.
    ASSERT sy-subrc = 0.

    lo_ecatt_vo = <lg_ecatt_vo>.

    li_objects_node = template_over_all->create_simple_element(
                                           name   = 'BUSINESS_MESSAGES'
                                           parent = root_node ).

    CALL METHOD lo_ecatt_vo->('GET_BUSSINESS_MSG')
      IMPORTING
        ex_buss_msg_ref = lt_buss_msg_ref.

    CALL FUNCTION 'SDIXML_DATA_TO_DOM'
      EXPORTING
        name         = 'ETVO_MSG'
        dataobject   = lt_buss_msg_ref
      IMPORTING
        data_as_dom  = li_element
      CHANGING
        document     = template_over_all
      EXCEPTIONS
        illegal_name = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    li_insert_objects ?= template_over_all->find_from_name( 'BUSINESS_MESSAGES' ).

    li_insert_objects->append_child( new_child = li_element ).

  ENDMETHOD.


  METHOD set_ecatt_flags.

    DATA:
      lv_invert_validation TYPE yif_abapgit_ecatt=>etvo_invert_validation,
      lv_error_prio        TYPE yif_abapgit_ecatt=>etvo_error_prio,
      li_element           TYPE REF TO if_ixml_element,
      li_insert_objects    TYPE REF TO if_ixml_element,
      lo_ecatt_vo          TYPE REF TO object.

    FIELD-SYMBOLS: <lg_ecatt_vo> TYPE any.

    li_objects_node = template_over_all->create_simple_element(
                                           name   = 'VO_FLAGS'
                                           parent = root_node ).

    ASSIGN ('ECATT_OBJECT') TO <lg_ecatt_vo>.
    ASSERT sy-subrc = 0.

    lo_ecatt_vo = <lg_ecatt_vo>.

    CALL METHOD lo_ecatt_vo->('GET_INVERT_VALIDATION_FLAG')
      RECEIVING
        re_invert_validation = lv_invert_validation.

    CALL FUNCTION 'SDIXML_DATA_TO_DOM'
      EXPORTING
        name         = 'INVERT_VALIDATION'
        dataobject   = lv_invert_validation
      IMPORTING
        data_as_dom  = li_element
      CHANGING
        document     = template_over_all
      EXCEPTIONS
        illegal_name = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    li_insert_objects ?= template_over_all->find_from_name( 'VO_FLAGS' ).

    li_insert_objects->append_child( new_child = li_element ).

    CALL METHOD lo_ecatt_vo->('GET_ERROR_PRIORITY')
      RECEIVING
        re_error_prio = lv_error_prio.

    CALL FUNCTION 'SDIXML_DATA_TO_DOM'
      EXPORTING
        name         = 'ERROR_PRIORITY'
        dataobject   = lv_error_prio
      IMPORTING
        data_as_dom  = li_element
      CHANGING
        document     = template_over_all
      EXCEPTIONS
        illegal_name = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    li_insert_objects = template_over_all->find_from_name( 'VO_FLAGS' ).

    li_insert_objects->append_child( new_child = li_element ).

  ENDMETHOD.


  METHOD set_ecatt_impl_detail.

    DATA:
      ls_impl_details   TYPE yif_abapgit_ecatt=>etvoimpl_det,
      li_element        TYPE REF TO if_ixml_element,
      li_insert_objects TYPE REF TO if_ixml_element,
      lo_ecatt_vo       TYPE REF TO object.

    FIELD-SYMBOLS: <lg_ecatt_vo> TYPE any.

    li_objects_node = template_over_all->create_simple_element(
                                           name   = 'IMPL_DETAILS'
                                           parent = root_node ).

    ASSIGN ('ECATT_OBJECT') TO <lg_ecatt_vo>.
    ASSERT sy-subrc = 0.

    lo_ecatt_vo = <lg_ecatt_vo>.

    CALL METHOD lo_ecatt_vo->('GET_IMPL_DETAILS')
      RECEIVING
        re_impl_details = ls_impl_details.

    CALL FUNCTION 'SDIXML_DATA_TO_DOM'
      EXPORTING
        name         = 'IMPL_DET'
        dataobject   = ls_impl_details
      IMPORTING
        data_as_dom  = li_element
      CHANGING
        document     = template_over_all
      EXCEPTIONS
        illegal_name = 1
        OTHERS       = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    li_insert_objects = template_over_all->find_from_name( 'IMPL_DETAILS' ).

    li_insert_objects->append_child( new_child = li_element ).

  ENDMETHOD.
ENDCLASS.
