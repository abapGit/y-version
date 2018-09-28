INTERFACE yif_abapgit_object_enho PUBLIC.

  METHODS:
    deserialize
      IMPORTING io_xml     TYPE REF TO ycl_abapgit_xml_input
                iv_package TYPE devclass
      RAISING   ycx_abapgit_exception,
    serialize
      IMPORTING io_xml      TYPE REF TO ycl_abapgit_xml_output
                ii_enh_tool TYPE REF TO if_enh_tool
      RAISING   ycx_abapgit_exception.

ENDINTERFACE.
