module JsEnv
  extend ActiveSupport::Concern

  included do
    helper_method :js_env
  end

  def js_env
    data = {
      env: Rails.env,
      templates: templates,
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
        Rails.application.assets.each_logical_path
        .select { |file| file.end_with?('swf', 'html', 'json') }
        .map { |file| [file, ActionController::Base.helpers.asset_path(file)] }
      ]
    end
end
