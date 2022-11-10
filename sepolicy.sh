# debug
magiskpolicy --live "dontaudit system_server system_file file write"
magiskpolicy --live "allow     system_server system_file file write"

# dir
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } blkio_dev dir search"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } blkio_dev dir search"

# file
magiskpolicy --live "dontaudit mm-qcamerad camera_prop file { read open getattr }"
magiskpolicy --live "allow     mm-qcamerad camera_prop file { read open getattr }"
magiskpolicy --live "dontaudit hal_camera_default { bootanim_system_prop default_prop } file getattr"
magiskpolicy --live "allow     hal_camera_default { bootanim_system_prop default_prop } file getattr"
magiskpolicy --live "dontaudit mm-qcamerad vendor_camera_data_file file create"
magiskpolicy --live "allow     mm-qcamerad vendor_camera_data_file file create"

# sock_file
magiskpolicy --live "dontaudit { cameraserver mm-qcamerad } property_socket sock_file write"
magiskpolicy --live "allow     { cameraserver mm-qcamerad } property_socket sock_file write"

# unix_stream_socket
magiskpolicy --live "dontaudit { cameraserver mm-qcamerad } init unix_stream_socket connectto"
magiskpolicy --live "allow     { cameraserver mm-qcamerad } init unix_stream_socket connectto"

# property_service
magiskpolicy --live "dontaudit cameraserver system_prop property_service set"
magiskpolicy --live "allow     cameraserver system_prop property_service set"
magiskpolicy --live "dontaudit mm-qcamerad camera_prop property_service set"
magiskpolicy --live "allow     mm-qcamerad camera_prop property_service set"

# additional for gcam
magiskpolicy --live "dontaudit { system_app platform_app priv_app untrusted_app_29 untrusted_app_27 untrusted_app } app_data_file file execute"
magiskpolicy --live "allow     { system_app platform_app priv_app untrusted_app_29 untrusted_app_27 untrusted_app } app_data_file file execute"
magiskpolicy --live "dontaudit { system_app platform_app priv_app untrusted_app_29 untrusted_app_27 untrusted_app } vendor_persist_camera_prop file { read open getattr }"
magiskpolicy --live "allow     { system_app platform_app priv_app untrusted_app_29 untrusted_app_27 untrusted_app } vendor_persist_camera_prop file { read open getattr }"


