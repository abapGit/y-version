CLASS ycl_abapgit_gui_view_tutorial DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES yif_abapgit_gui_page.
    INTERFACES yif_abapgit_gui_page_hotkey.
    ALIASES render FOR yif_abapgit_gui_page~render.

  PRIVATE SECTION.
    METHODS render_content
      RETURNING VALUE(ro_html) TYPE REF TO ycl_abapgit_html.

ENDCLASS.



CLASS YCL_ABAPGIT_GUI_VIEW_TUTORIAL IMPLEMENTATION.


  METHOD render_content.

    CREATE OBJECT ro_html.

    ro_html->add( '<h1>Tutorial</h1>' ).
    ro_html->add( '<hr>' ).

    ro_html->add( '<h2>Adding and cloning repos</h2>' ).
    ro_html->add( '<p><ul>' ).

    ro_html->add( `<li>To clone a remote repo (e.g. from github) click ` ).
    ro_html->add_a( iv_txt = '+ Online' iv_act = yif_abapgit_definitions=>c_action-repo_newonline ).
    ro_html->add( ' from the top menu. This will copy a remote repo to your system.</li>' ).

    ro_html->add( `<li>To add a local package as a repo click ` ).
    ro_html->add_a( iv_txt = '+ Offline' iv_act = yif_abapgit_definitions=>c_action-repo_newoffline ).
    ro_html->add( ' from the top menu. This will track a repo which already exist in' ).
    ro_html->add( ' the system with abapGit. You''ll be able to attach it to remote origin' ).
    ro_html->add( ' or just serialize as a zip file</li>' ).

    ro_html->add( `<li>Go ` ).
    ro_html->add_a( iv_txt = 'Explore' iv_act = yif_abapgit_definitions=>c_action-go_explore ).
    ro_html->add( ' to find projects using abapGit</li>' ).

    ro_html->add( '</ul></p>' ).

    ro_html->add( '<h2>Repository list and favorites</h2>' ).
    ro_html->add( '<p><ul>' ).
    ro_html->add( |<li>To choose a repo press {
                  ycl_abapgit_html=>icon( 'three-bars/blue' ) } at the favorite bar.</li>| ).
    ro_html->add( |<li>To favorite a repo click {
                  ycl_abapgit_html=>icon( 'star/darkgrey' ) } icon at repo toolbar.</li>| ).
    ro_html->add( '</ul></p>' ).

    ro_html->add( '<h2>abapGit repository</h2>' ).
    ro_html->add( '<p><ul>' ).
    ro_html->add( '<li>' ).
    IF ycl_abapgit_services_abapgit=>is_installed( ) = abap_true.
      ro_html->add( 'abapGit installed in package&nbsp;' ).
      ro_html->add( ycl_abapgit_services_abapgit=>c_package_abapgit ).
    ELSE.
      ro_html->add_a( iv_txt = 'install abapGit repo' iv_act = yif_abapgit_definitions=>c_action-abapgit_install ).
      ro_html->add( ' - To keep abapGit up-to-date (or also to contribute) you need to' ).
      ro_html->add( 'install it as a repository.' ).
    ENDIF.
    ro_html->add( '</li>' ).
    ro_html->add( '</ul></p>' ).

  ENDMETHOD.


  METHOD yif_abapgit_gui_page_hotkey~get_hotkey_actions.

  ENDMETHOD.


  METHOD yif_abapgit_gui_page~on_event.
    ev_state = yif_abapgit_definitions=>c_event_state-not_handled.
  ENDMETHOD.


  METHOD yif_abapgit_gui_page~render.

    CREATE OBJECT ro_html.

    ro_html->add( '<div class="tutorial">' ).
    ro_html->add( render_content( ) ).
    ro_html->add( '</div>' ).

  ENDMETHOD.
ENDCLASS.
