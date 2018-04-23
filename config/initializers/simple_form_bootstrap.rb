SimpleForm.setup do |config|
  help_block = 'br0 ba pv1 ph2 mb2 white b--dark-red bg-light-pink'
  config.error_notification_class = help_block
  config.button_class = 'b mv3 ph3 pv2 input-reset ba b--black bg-transparent grow pointer f6 dib'
  config.boolean_label_class = 'pa0 ma0 lh-copy f6 pointer'
  config.default_form_class = 'measure-wide center'

  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'db fw6 lh-copy f6'

    b.use :input, class: 'pa2 input-reset ba bg-transparent w-100 measure-wide'
    b.use :error, wrap_with: { tag: 'div', class: help_block }
    b.use :hint,  wrap_with: { tag: 'div', class: help_block }
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'db fw6 lh-copy f6'

    b.use :input
    b.use :error, wrap_with: { tag: 'div', class: help_block }
    b.use :hint,  wrap_with: { tag: 'div', class: help_block }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'pa0 ma0 lh-copy f6 pointer' do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: { tag: 'div', class: help_block }
    b.use :hint,  wrap_with: { tag: 'p', class: help_block }
  end

  config.wrappers :vertical_radio_and_checkboxes, tag: 'div', class: '', :error_class => 'error' do |b|
    b.use :html5
    b.wrapper :tag => 'div', :class => '' do |ba|
      ba.wrapper :tag => 'label', :class => '' do |bb|
        bb.use :input
        bb.use :label_text, class: 'pa0 ma0 lh-copy f6 pointer'
      end
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'div', :class => help_block }
    end
  end

  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
    check_boxes: :vertical_radio_and_checkboxes,
    radio_buttons: :vertical_radio_and_checkboxes,
    file: :vertical_file_input,
    boolean: :vertical_boolean,
  }
end
