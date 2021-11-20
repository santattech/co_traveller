module ApplicationHelper
  def unobtrusive_js(code)
    if request.xhr?
      "<script type='text/javascript'>#{code}</script>".html_safe
    else
      content_for :unobtrusive_javascript do
        "<script type='text/javascript'>#{code}</script>".html_safe
      end
    end
  end

end
