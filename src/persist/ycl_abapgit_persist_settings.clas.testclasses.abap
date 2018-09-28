CLASS ltcl_persistence_settings DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL DANGEROUS.

  PRIVATE SECTION.
    CLASS-METHODS:
      class_setup.

    METHODS:
      setup,
      clear_settings_database,
      "Proxy
      modify_settings_proxy_url     FOR TESTING RAISING cx_static_check,
      modify_settings_proxy_port    FOR TESTING RAISING cx_static_check,
      read_proxy_settings           FOR TESTING RAISING cx_static_check,
      read_not_found_url            FOR TESTING RAISING cx_static_check,
      read_not_found_port           FOR TESTING RAISING cx_static_check,
      "Run critical tests
      modify_run_critical_tests     FOR TESTING RAISING cx_static_check,
      read_run_critical_tests       FOR TESTING RAISING cx_static_check,
      read_not_found_critical_tests FOR TESTING RAISING cx_static_check.
    DATA:
      mo_persistence_settings TYPE REF TO ycl_abapgit_persist_settings,
      mo_settings             TYPE REF TO ycl_abapgit_settings.
ENDCLASS.

CLASS ltcl_persistence_settings IMPLEMENTATION.

  METHOD class_setup.
    "Objects will be created and deleted, do not run in customer system!
    "These tests may fail if you are locking the entries (e.g. the YABAPGIT transaction is open)
    IF ycl_abapgit_persist_settings=>get_instance( )->read( )->get_run_critical_tests( ) = abap_false.
      cl_abap_unit_assert=>fail(
        msg   = 'Cancelled. You can enable these tests at the Settings page'
        level = if_aunit_constants=>tolerable ).
    ENDIF.
  ENDMETHOD.

  METHOD setup.
    mo_persistence_settings = ycl_abapgit_persist_settings=>get_instance( ).
    CREATE OBJECT mo_settings.
    clear_settings_database( ).
  ENDMETHOD.

  METHOD modify_settings_proxy_url.
    DATA lv_proxy_url TYPE string.

    mo_settings->set_proxy_url( 'http://proxy' ).

    mo_persistence_settings->modify( mo_settings ).

    lv_proxy_url = ycl_abapgit_persistence_db=>get_instance( )->read(
      iv_type  = 'SETTINGS'
      iv_value = 'PROXY_URL' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_proxy_url
      exp = 'http://proxy' ).
  ENDMETHOD.

  METHOD modify_settings_proxy_port.
    DATA lv_proxy_port TYPE string.
    mo_settings->set_proxy_port( '8080' ).

    mo_persistence_settings->modify( mo_settings ).

    lv_proxy_port = ycl_abapgit_persistence_db=>get_instance( )->read(
      iv_type  = 'SETTINGS'
      iv_value = 'PROXY_PORT' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_proxy_port
      exp = '8080' ).
  ENDMETHOD.

  METHOD read_proxy_settings.
    ycl_abapgit_persistence_db=>get_instance( )->modify(
      iv_type       = 'SETTINGS'
      iv_value      = 'PROXY_URL'
      iv_data       = 'A_URL' ).

    ycl_abapgit_persistence_db=>get_instance( )->modify(
      iv_type       = 'SETTINGS'
      iv_value      = 'PROXY_PORT'
      iv_data       = '1000' ).

    mo_settings = mo_persistence_settings->read( ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_settings->get_proxy_url( )
      exp = 'A_URL' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_settings->get_proxy_port( )
      exp = '1000' ).
  ENDMETHOD.

  METHOD read_not_found_port.
    mo_settings = mo_persistence_settings->read( ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_settings->get_proxy_port( )
      exp = '' ).
  ENDMETHOD.

  METHOD read_not_found_url.

    mo_settings = mo_persistence_settings->read( ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_settings->get_proxy_url( )
      exp = '' ).
  ENDMETHOD.

  METHOD modify_run_critical_tests.
    DATA lv_run_critical_tests TYPE abap_bool.
    mo_settings->set_run_critical_tests( abap_true ).

    mo_persistence_settings->modify( mo_settings ).

    lv_run_critical_tests = ycl_abapgit_persistence_db=>get_instance( )->read(
      iv_type  = 'SETTINGS'
      iv_value = 'CRIT_TESTS' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_run_critical_tests
      exp = abap_true ).
  ENDMETHOD.

  METHOD read_run_critical_tests.
    ycl_abapgit_persistence_db=>get_instance( )->modify(
      iv_type       = 'SETTINGS'
      iv_value      = 'CRIT_TESTS'
      iv_data       = 'X' ).
    mo_settings = mo_persistence_settings->read( ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_settings->get_run_critical_tests( )
      exp = abap_true ).
  ENDMETHOD.
  METHOD read_not_found_critical_tests.
    mo_settings = mo_persistence_settings->read( ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_settings->get_run_critical_tests( )
      exp = abap_false ).
  ENDMETHOD.


  METHOD clear_settings_database.

    TRY.
        ycl_abapgit_persistence_db=>get_instance( )->delete(
          iv_type       = 'SETTINGS'
          iv_value      = 'PROXY_URL' ).
      CATCH cx_static_check ##NO_HANDLER.
        "If entry didn't exist, that's okay
    ENDTRY.
    TRY.
        ycl_abapgit_persistence_db=>get_instance( )->delete(
          iv_type       = 'SETTINGS'
          iv_value      = 'PROXY_PORT' ).
      CATCH cx_static_check ##NO_HANDLER.
        "If entry didn't exist, that's okay
    ENDTRY.
    TRY.
        ycl_abapgit_persistence_db=>get_instance( )->delete(
          iv_type       = 'SETTINGS'
          iv_value      = 'CRIT_TESTS' ).
      CATCH cx_static_check ##NO_HANDLER.
        "If entry didn't exist, that's okay
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
