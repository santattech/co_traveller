module ApplicationHelper
  include ActionView::Helpers::DateHelper
  def unobtrusive_js(code)
    if request.xhr?
      "<script type='text/javascript'>#{code}</script>".html_safe
    else
      content_for :unobtrusive_javascript do
        "<script type='text/javascript'>#{code}</script>".html_safe
      end
    end
  end

  def dist_of_time_in_words(time)
    time_ago_in_words(time) + ' ago'
  end
end
