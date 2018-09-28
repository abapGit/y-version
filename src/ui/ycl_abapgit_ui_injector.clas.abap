CLASS ycl_abapgit_ui_injector DEFINITION
  PUBLIC
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      set_popups
        IMPORTING
          ii_popups TYPE REF TO yif_abapgit_popups,

      set_tag_popups
        IMPORTING
          ii_tag_popups TYPE REF TO yif_abapgit_tag_popups.

ENDCLASS.



CLASS ycl_abapgit_ui_injector IMPLEMENTATION.

  METHOD set_popups.

    ycl_abapgit_ui_factory=>mi_popups = ii_popups.

  ENDMETHOD.

  METHOD set_tag_popups.

    ycl_abapgit_ui_factory=>mi_tag_popups = ii_tag_popups.

  ENDMETHOD.

ENDCLASS.
