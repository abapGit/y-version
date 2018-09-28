INTERFACE yif_abapgit_code_inspector
  PUBLIC.

  METHODS:
    run
      RETURNING
        VALUE(rt_list) TYPE scit_alvlist
      RAISING
        ycx_abapgit_exception,

    get_inspection
      RETURNING
        VALUE(ro_inspection) TYPE REF TO cl_ci_inspection.

ENDINTERFACE.
