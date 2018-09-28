
CLASS ltcl_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      adler32 FOR TESTING,
      sha1 FOR TESTING RAISING ycx_abapgit_exception.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD adler32.

    DATA: lv_adler TYPE yif_abapgit_definitions=>ty_adler32.

    lv_adler = ycl_abapgit_hash=>adler32( '1122334455667788' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_adler
      exp = '08000265' ).

  ENDMETHOD.

  METHOD sha1.

    DATA: lv_sha1 TYPE yif_abapgit_definitions=>ty_sha1.

    lv_sha1 = ycl_abapgit_hash=>sha1(
      iv_type = yif_abapgit_definitions=>c_type-commit
      iv_data = '112211221122' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_sha1
      exp = 'af2261a340c5188baf86a64a581d22012303023c' ).

  ENDMETHOD.

ENDCLASS.
