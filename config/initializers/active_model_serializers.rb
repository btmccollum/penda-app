ActiveModelSerializers.config.tap do |c|
  c.adapter = :json
  c.jsonapi_include_toplevel_object = true
  c.jsonapi_version = "1.0"
end