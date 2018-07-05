# f.input(:my_rating_column, as: :star_rating)
# https://gist.github.com/blairanderson/7f9d1c08345c6573e09edaa1f7316fa1
class StarRatingInput < SimpleForm::Inputs::Base
  def input
    template.content_tag(:div, class: 'input-group date form_datetime') do
      template.concat @builder.text_field(attribute_name, input_html_options)
      template.concat span_remove
      template.concat span_table
    end
  end

  def input_html_options
    super.merge({class: 'form-control', readonly: true})
  end

  def span_remove
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat(icon_remove)
    end
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat(icon_table)
    end
  end

  def icon_remove
    "<i class='glyphicon glyphicon-remove'></i>".html_safe
  end

  def icon_table
    "<i class='glyphicon glyphicon-th'></i>".html_safe
  end

end
