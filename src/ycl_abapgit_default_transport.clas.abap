CLASS ycl_abapgit_default_transport DEFINITION
  PUBLIC
  CREATE PRIVATE .

  PUBLIC SECTION.
    CLASS-METHODS:
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO ycl_abapgit_default_transport
        RAISING
          ycx_abapgit_exception.

    METHODS:
      constructor
        RAISING
          ycx_abapgit_exception,

      set
        IMPORTING
          iv_transport TYPE trkorr
        RAISING
          ycx_abapgit_exception,

      reset
        RAISING
          ycx_abapgit_exception.


  PRIVATE SECTION.

    CLASS-DATA:
      mo_instance TYPE REF TO ycl_abapgit_default_transport .

    DATA:
      mv_is_set_by_abapgit TYPE abap_bool,
      ms_save              TYPE e070use.

    METHODS:
      store
        RAISING
          ycx_abapgit_exception,

      restore
        RAISING
          ycx_abapgit_exception,

      get
        RETURNING
          VALUE(rs_default_task) TYPE e070use
        RAISING
          ycx_abapgit_exception,

      set_internal
        IMPORTING
          iv_transport TYPE trkorr
        RAISING
          ycx_abapgit_exception,

      clear
        IMPORTING
          is_default_task TYPE e070use
        RAISING
          ycx_abapgit_exception.

ENDCLASS.



CLASS ycl_abapgit_default_transport IMPLEMENTATION.

  METHOD clear.

    CALL FUNCTION 'TR_TASK_RESET'
      EXPORTING
        iv_username      = is_default_task-username
        iv_order         = is_default_task-ordernum
        iv_task          = is_default_task-tasknum
        iv_dialog        = abap_false
      EXCEPTIONS
        invalid_username = 1
        invalid_order    = 2
        invalid_task     = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( |Error from TR_TASK_RESET { sy-subrc }| ).
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    store( ).

  ENDMETHOD.


  METHOD get.

    DATA: lt_e070use TYPE STANDARD TABLE OF e070use.

    CALL FUNCTION 'TR_TASK_GET'
      TABLES
        tt_e070use       = lt_e070use
      EXCEPTIONS
        invalid_username = 1
        invalid_category = 2
        invalid_client   = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( |Error from TR_TASK_GET { sy-subrc }| ).
    ENDIF.

    READ TABLE lt_e070use INTO rs_default_task
                          INDEX 1.

  ENDMETHOD.


  METHOD get_instance.

    IF mo_instance IS NOT BOUND.
      CREATE OBJECT mo_instance.
    ENDIF.

    ro_instance = mo_instance.

  ENDMETHOD.


  METHOD reset.

    DATA: ls_default_task TYPE e070use.

    IF mv_is_set_by_abapgit = abap_false.
      " if the default transport request task isn't set
      " by us there is nothing to do.
      RETURN.
    ENDIF.

    CLEAR mv_is_set_by_abapgit.

    ls_default_task = get( ).

    IF ls_default_task IS NOT INITIAL.

      clear( ls_default_task ).

    ENDIF.

    restore( ).

  ENDMETHOD.


  METHOD restore.

    IF ms_save IS INITIAL.
      " There wasn't a default transport request before
      " so we needn't restore anything.
      RETURN.
    ENDIF.

    CALL FUNCTION 'TR_TASK_SET'
      EXPORTING
        iv_order          = ms_save-ordernum
        iv_task           = ms_save-tasknum
      EXCEPTIONS
        invalid_username  = 1
        invalid_category  = 2
        invalid_client    = 3
        invalid_validdays = 4
        invalid_order     = 5
        invalid_task      = 6
        OTHERS            = 7.

    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( |Error from TR_TASK_SET { sy-subrc }| ).
    ENDIF.

  ENDMETHOD.


  METHOD set.

    " checks whether object changes of the package are rerorded in transport
    " requests. If true then we set the default task, so that no annoying
    " transport request popups are shown while deserializing.

    IF mv_is_set_by_abapgit = abap_true.
      " the default transport request task is already set by us
      " -> no reason to do it again.
      RETURN.
    ENDIF.

    IF iv_transport IS INITIAL.
      ycx_abapgit_exception=>raise( |No transport request was supplied| ).
    ENDIF.

    set_internal( iv_transport ).

    mv_is_set_by_abapgit = abap_true.

  ENDMETHOD.


  METHOD set_internal.

    CALL FUNCTION 'TR_TASK_SET'
      EXPORTING
        iv_order          = iv_transport
*       iv_task           = iv_task
      EXCEPTIONS
        invalid_username  = 1
        invalid_category  = 2
        invalid_client    = 3
        invalid_validdays = 4
        invalid_order     = 5
        invalid_task      = 6
        OTHERS            = 7.

    IF sy-subrc <> 0.
      ycx_abapgit_exception=>raise( |Error from TR_TASK_SET { sy-subrc }| ).
    ENDIF.

  ENDMETHOD.


  METHOD store.

    ms_save = get( ).

  ENDMETHOD.
ENDCLASS.