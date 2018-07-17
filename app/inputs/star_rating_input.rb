# f.input(:my_rating_column, as: :star_rating)
# https://gist.github.com/blairanderson/7f9d1c08345c6573e09edaa1f7316fa1
class StarRatingInput < SimpleForm::Inputs::Base
  def input
    template.content_tag(:div, class: 'rating') do
      {
        5 => "Rocks",
        4 => "Pretty Good",
        3 => "Meh",
        2 => "Kinda Bad",
        1 => "Sucks Big Time"
      }.each do |rating, title|
        input_html_options = super.merge({
            class: '',
            id: "star#{rating}",
            checked: ("checked" if object.send("#{attribute_name}") == rating),
            onchange: "this.form_submit()",
            value: rating
          })

        template.concat(@builder.radio_tag(attribute_name,input_html_options))
        template.concat(template.content_tag(:label, "#{rating} stars", title: title, for: "star#{rating}"))
      end
    end
  end
end
