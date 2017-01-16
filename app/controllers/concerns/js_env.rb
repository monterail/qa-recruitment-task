module JsEnv
  extend ActiveSupport::Concern

  included do
    helper_method :js_env
  end

  def js_env
    data = {
      env: Rails.env,
      templates: templates,
      logout_url: destroy_user_session_path,
    }

    <<-EOS.html_safe
      <script type="text/javascript">
        angular.module('BornApp').constant('Rails', #{data.to_json})
       </script>
    EOS
  end

  private

  def templates
    Hash[
      Rails.application.assets.logical_paths
        .select { |file, _path| file.end_with?("swf", "html", "json") }
        .map { |file, _path| file == "..html" ? "index.html" : file } # because of http://www.rubydoc.info/gems/sprockets/3.2.0/Sprockets%2FBase%3Anormalize_logical_path
        .map { |file| [file, ActionController::Base.helpers.asset_path(file)] }
    ]
  end
end
