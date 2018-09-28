CLASS ycl_abapgit_comparison_null DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES yif_abapgit_comparison_result .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_ABAPGIT_COMPARISON_NULL IMPLEMENTATION.


  METHOD yif_abapgit_comparison_result~is_result_complete_halt.
    rv_response = abap_false.
  ENDMETHOD.


  METHOD yif_abapgit_comparison_result~show_confirmation_dialog.
    RETURN.
  ENDMETHOD.
ENDCLASS.
