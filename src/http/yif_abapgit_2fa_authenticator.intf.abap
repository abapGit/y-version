"! Defines a two factor authentication authenticator
"! <p>
"! Authenticators support one or multiple services and are able to generate access tokens using the
"! service's API using the users username, password and two factor authentication token
"! (app/sms/tokengenerator). With these access tokens the user can be authenticated to the service's
"! implementation of the git http api, just like the "normal" password would.
"! </p>
"! <p>
"! {@link YCL_ABAPGIT_2FA_AUTH_REGISTRY} can be used to find a suitable implementation for a
"! given repository.
"! </p>
"! <p>
"! Using the {@link yif_abapgit_2fa_authenticator.METH:begin} and
"! {@link yif_abapgit_2fa_authenticator.METH.end} methods an internal session can be started and
"! completed in which internal state necessary for multiple methods will be cached. This can be
"! used to avoid having multiple http sessions between
"! {@link yif_abapgit_2fa_authenticator.METH:authenticate} and
"! {@link yif_abapgit_2fa_authenticator.METH:delete_access_tokens}.
"! </p>
INTERFACE yif_abapgit_2fa_authenticator PUBLIC.
  "! Generate an access token
  "! @parameter iv_url | Repository url
  "! @parameter iv_username | Username
  "! @parameter iv_password | Password
  "! @parameter iv_2fa_token | Two factor token
  "! @parameter rv_access_token | Generated access token
  "! @raising ycx_abapgit_2fa_auth_failed | Authentication failed
  "! @raising ycx_abapgit_2fa_gen_failed | Token generation failed
  METHODS authenticate
    IMPORTING
      !iv_url                TYPE string
      !iv_username           TYPE string
      !iv_password           TYPE string
      !iv_2fa_token          TYPE string
    RETURNING
      VALUE(rv_access_token) TYPE string
    RAISING
      ycx_abapgit_2fa_auth_failed
      ycx_abapgit_2fa_gen_failed
      ycx_abapgit_2fa_comm_error .
  "! Check if this authenticator instance supports the given repository url
  "! @parameter iv_url | Repository url
  "! @parameter rv_supported | Is supported
  METHODS supports_url
    IMPORTING
      !iv_url             TYPE string
    RETURNING
      VALUE(rv_supported) TYPE abap_bool .
  "! Check if two factor authentication is required
  "! @parameter iv_url | Repository url
  "! @parameter iv_username | Username
  "! @parameter iv_password | Password
  "! @parameter rv_required | 2FA is required
  METHODS is_2fa_required
    IMPORTING
      !iv_url            TYPE string
      !iv_username       TYPE string
      !iv_password       TYPE string
    RETURNING
      VALUE(rv_required) TYPE abap_bool
    RAISING
      ycx_abapgit_2fa_comm_error .
  "! Delete all previously created access tokens for abapGit
  "! @parameter iv_url | Repository url
  "! @parameter iv_username | Username
  "! @parameter iv_password | Password
  "! @parameter iv_2fa_token | Two factor token
  "! @raising ycx_abapgit_2fa_del_failed | Token deletion failed
  "! @raising ycx_abapgit_2fa_auth_failed | Authentication failed
  METHODS delete_access_tokens
    IMPORTING
      !iv_url       TYPE string
      !iv_username  TYPE string
      !iv_password  TYPE string
      !iv_2fa_token TYPE string
    RAISING
      ycx_abapgit_2fa_del_failed
      ycx_abapgit_2fa_comm_error
      ycx_abapgit_2fa_auth_failed .
  "! Begin an authenticator session that uses internal caching for authorizations
  "! @raising ycx_abapgit_2fa_illegal_state | Session already started
  METHODS begin
    RAISING
      ycx_abapgit_2fa_illegal_state .
  "! End an authenticator session and clear internal caches
  "! @raising ycx_abapgit_2fa_illegal_state | Session not running
  METHODS end
    RAISING
      ycx_abapgit_2fa_illegal_state .
ENDINTERFACE.
