CLASS ycl_abapgit_object_cus1 DEFINITION PUBLIC INHERITING FROM ycl_abapgit_objects_super FINAL.

  PUBLIC SECTION.
    INTERFACES yif_abapgit_object.
    ALIASES mo_files FOR yif_abapgit_object~mo_files.

    METHODS constructor
      IMPORTING
        is_item     TYPE yif_abapgit_definitions=>ty_item
        iv_language TYPE spras.

  PRIVATE SECTION.
    TYPES: tty_activity_titles TYPE STANDARD TABLE OF cus_actt
                                    WITH NON-UNIQUE DEFAULT KEY,

           tty_objects         TYPE STANDARD TABLE OF cus_actobj
                            WITH NON-UNIQUE DEFAULT KEY,

           tty_objects_title   TYPE STANDARD TABLE OF cus_actobt
                                  WITH NON-UNIQUE DEFAULT KEY,

           BEGIN OF ty_customzing_activity,
             activity_header        TYPE cus_acth,
             activity_customer_exit TYPE cus_actext,
             activity_title         TYPE tty_activity_titles,
             objects                TYPE tty_objects,
             objects_title          TYPE tty_objects_title,
           END OF ty_customzing_activity.

    DATA: mv_customizing_activity TYPE cus_img_ac.

ENDCLASS.

CLASS ycl_abapgit_object_cus1 IMPLEMENTATION.

  METHOD constructor.

    super->constructor( is_item = is_item
                        iv_language = iv_language ).

    mv_customizing_activity = ms_item-obj_name.

  ENDMETHOD.

  METHOD yif_abapgit_object~has_changed_since.
    rv_changed = abap_true.
  ENDMETHOD.

  METHOD yif_abapgit_object~changed_by.
    rv_user = c_user_unknown.
  ENDMETHOD.

  METHOD yif_abapgit_object~get_metadata.
    rs_metadata = get_metadata( ).
    rs_metadata-delete_tadir = abap_true.
  ENDMETHOD.

  METHOD yif_abapgit_object~jump.

    ycx_abapgit_exception=>raise( |TODO: Jump| ).

  ENDMETHOD.

  METHOD yif_abapgit_object~exists.

    CALL FUNCTION 'S_CUS_ACTIVITY_EXIST'
      EXPORTING
        activity            = mv_customizing_activity
      EXCEPTIONS
        activity_exists_not = 1
        OTHERS              = 2.

    rv_bool = boolc( sy-subrc = 0 ).

  ENDMETHOD.

  METHOD yif_abapgit_object~delete.

    DATA: ls_message TYPE hier_mess.

    CALL FUNCTION 'S_CUS_ACTIVITY_DELETE'
      EXPORTING
        activity = mv_customizing_activity
      IMPORTING
        message  = ls_message.

    IF ls_message-msgty <> 'S'.
      ycx_abapgit_exception=>raise( |error from delete CUS1 { mv_customizing_activity } S_CUS_ACTIVITY_DELETE| ).
    ENDIF.

  ENDMETHOD.

  METHOD yif_abapgit_object~serialize.

    DATA: ls_customzing_activity TYPE ty_customzing_activity.

    CALL FUNCTION 'S_CUS_ACTIVITY_READ'
      EXPORTING
        activity               = mv_customizing_activity
      IMPORTING
        activity_header        = ls_customzing_activity-activity_header
        activity_customer_exit = ls_customzing_activity-activity_customer_exit
      TABLES
        activity_title         = ls_customzing_activity-activity_title
        objects                = ls_customzing_activity-objects
        objects_title          = ls_customzing_activity-objects_title.

    CLEAR: ls_customzing_activity-activity_header-fdatetime,
           ls_customzing_activity-activity_header-fuser,
           ls_customzing_activity-activity_header-ldatetime,
           ls_customzing_activity-activity_header-luser.

    io_xml->add( iv_name = 'CUS1'
                 ig_data = ls_customzing_activity ).

  ENDMETHOD.

  METHOD yif_abapgit_object~deserialize.

    DATA: ls_customzing_activity TYPE ty_customzing_activity,
          ls_message             TYPE hier_mess.

    io_xml->read(
      EXPORTING
        iv_name = 'CUS1'
      CHANGING
        cg_data = ls_customzing_activity ).

    CALL FUNCTION 'S_CUS_ACTIVITY_SAVE'
      EXPORTING
        activity                     = ls_customzing_activity-activity_header-act_id
        activity_type                = ls_customzing_activity-activity_header-act_type
        tcode                        = ls_customzing_activity-activity_header-tcode
        customer_exit                = ls_customzing_activity-activity_customer_exit-exit_name
        customer_exit_enhancement    = ls_customzing_activity-activity_customer_exit-enhancement
        customer_exit_implementation = ls_customzing_activity-activity_customer_exit-impl_name
      IMPORTING
        message                      = ls_message
      TABLES
        activity_title               = ls_customzing_activity-activity_title
        objects                      = ls_customzing_activity-objects
        objects_texts                = ls_customzing_activity-objects_title.

    IF ls_message-msgty <> 'S'.
      ycx_abapgit_exception=>raise( |error from deserialize CUS1 { mv_customizing_activity } S_CUS_ACTIVITY_SAVE| ).
    ENDIF.

    CALL FUNCTION 'RS_CORR_INSERT'
      EXPORTING
        object              = ms_item-obj_name
        object_class        = ms_item-obj_type
        mode                = 'I'
        global_lock         = abap_true
        devclass            = iv_package
        master_language     = sy-langu
      EXCEPTIONS
        cancelled           = 1
        permission_failure  = 2
        unknown_objectclass = 3
        OTHERS              = 4.
    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( 'error from RS_CORR_INSERT, CUS0' ).
    ENDIF.

  ENDMETHOD.

  METHOD yif_abapgit_object~compare_to_remote_version.
    CREATE OBJECT ro_comparison_result TYPE ycl_abapgit_comparison_null.
  ENDMETHOD.

  METHOD yif_abapgit_object~is_locked.

    rv_is_locked = abap_false.

  ENDMETHOD.

ENDCLASS.
