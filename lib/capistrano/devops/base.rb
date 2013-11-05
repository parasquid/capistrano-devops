def template(from, to)
  tmpl = File.read(File.expand_path("../templates/#{from}", __FILE__))
  erb = ERB.new(tmpl).result(binding)
  execute :touch, "#{to}"
  upload! StringIO.new(erb), to
end
