INTERFACE yif_abapgit_gui_page PUBLIC.

  METHODS on_event
    IMPORTING iv_action    TYPE clike
              iv_prev_page TYPE clike
              iv_getdata   TYPE clike OPTIONAL
              it_postdata  TYPE cnht_post_data_tab OPTIONAL
    EXPORTING ei_page      TYPE REF TO yif_abapgit_gui_page
              ev_state     TYPE i
    RAISING   ycx_abapgit_exception ycx_abapgit_cancel.

  METHODS render
    RETURNING VALUE(ro_html) TYPE REF TO ycl_abapgit_html
    RAISING   ycx_abapgit_exception.

ENDINTERFACE.
