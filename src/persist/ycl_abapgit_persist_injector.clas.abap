CLASS ycl_abapgit_persist_injector DEFINITION
  PUBLIC
  CREATE PRIVATE
  FOR TESTING .

  PUBLIC SECTION.

    CLASS-METHODS set_repo
      IMPORTING
        !ii_repo TYPE REF TO yif_abapgit_persist_repo .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_ABAPGIT_PERSIST_INJECTOR IMPLEMENTATION.


  METHOD set_repo.

    ycl_abapgit_persist_factory=>gi_repo = ii_repo.

  ENDMETHOD.
ENDCLASS.
