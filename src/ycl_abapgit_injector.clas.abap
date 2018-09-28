CLASS ycl_abapgit_injector DEFINITION
  PUBLIC
  CREATE PRIVATE
  FOR TESTING .

  PUBLIC SECTION.

    CLASS-METHODS set_tadir
      IMPORTING
        !ii_tadir TYPE REF TO yif_abapgit_tadir .
    CLASS-METHODS set_sap_package
      IMPORTING
        !iv_package     TYPE devclass
        !ii_sap_package TYPE REF TO yif_abapgit_sap_package .
    CLASS-METHODS set_code_inspector
      IMPORTING
        !iv_package            TYPE devclass
        !iv_check_variant_name TYPE sci_chkv OPTIONAL
        !ii_code_inspector     TYPE REF TO yif_abapgit_code_inspector .
    CLASS-METHODS set_syntax_check
      IMPORTING
        !iv_package      TYPE devclass
        !ii_syntax_check TYPE REF TO yif_abapgit_code_inspector .
    CLASS-METHODS set_stage_logic
      IMPORTING
        !ii_logic TYPE REF TO yif_abapgit_stage_logic .
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_ABAPGIT_INJECTOR IMPLEMENTATION.


  METHOD set_code_inspector.

    DATA: ls_code_inspector LIKE LINE OF ycl_abapgit_factory=>gt_code_inspector.
    FIELD-SYMBOLS: <ls_code_inspector> LIKE LINE OF ycl_abapgit_factory=>gt_code_inspector.

    READ TABLE ycl_abapgit_factory=>gt_code_inspector
         ASSIGNING <ls_code_inspector>
         WITH TABLE KEY package            = iv_package
                        check_variant_name = iv_check_variant_name.
    IF sy-subrc <> 0.

      ls_code_inspector-package = iv_package.
      ls_code_inspector-check_variant_name = iv_check_variant_name.

      INSERT ls_code_inspector
             INTO TABLE ycl_abapgit_factory=>gt_code_inspector
             ASSIGNING <ls_code_inspector>.

    ENDIF.

    <ls_code_inspector>-instance = ii_code_inspector.

  ENDMETHOD.


  METHOD set_sap_package.

    DATA: ls_sap_package TYPE ycl_abapgit_factory=>ty_sap_package.
    FIELD-SYMBOLS: <ls_sap_package> TYPE ycl_abapgit_factory=>ty_sap_package.

    READ TABLE ycl_abapgit_factory=>gt_sap_package
         ASSIGNING <ls_sap_package>
         WITH TABLE KEY package = iv_package.

    IF sy-subrc <> 0.

      ls_sap_package-package = iv_package.
      INSERT ls_sap_package
             INTO TABLE ycl_abapgit_factory=>gt_sap_package
             ASSIGNING <ls_sap_package>.

    ENDIF.

    <ls_sap_package>-instance = ii_sap_package.

  ENDMETHOD.


  METHOD set_stage_logic.

    ycl_abapgit_factory=>gi_stage_logic = ii_logic.

  ENDMETHOD.


  METHOD set_syntax_check.

    DATA: ls_syntax_check LIKE LINE OF ycl_abapgit_factory=>gt_syntax_check.
    FIELD-SYMBOLS: <ls_syntax_check> LIKE LINE OF ycl_abapgit_factory=>gt_syntax_check.

    READ TABLE ycl_abapgit_factory=>gt_syntax_check
         ASSIGNING <ls_syntax_check>
         WITH TABLE KEY package = iv_package.
    IF sy-subrc <> 0.

      ls_syntax_check-package = iv_package.

      INSERT ls_syntax_check
             INTO TABLE ycl_abapgit_factory=>gt_syntax_check
             ASSIGNING <ls_syntax_check>.

    ENDIF.

    <ls_syntax_check>-instance = ii_syntax_check.

  ENDMETHOD.


  METHOD set_tadir.

    ycl_abapgit_factory=>gi_tadir = ii_tadir.

  ENDMETHOD.
ENDCLASS.
