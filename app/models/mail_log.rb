class MailLog < ActiveRecord::Base
  serialize :form_data, Hash

  validates_presence_of :form_name
  validates_presence_of :form_data

  def sent?
    success?
  end

  def unsent?
    !success?
  end

  def to_s
    if form_data.include?('name')
      form_data['name']
    elsif form_data.include?('email')
      form_data['email']
    else
      id.to_s
    end
  end
  def form_data=(form_data)
    # Strip attached files as they break serialisaion
    if form_data.has_key? 'attached_file'
      form_data['attached_file'] = form_data['attached_file'].try :original_filename
    end
    self[:form_data] = form_data.reject {|k,v| v.blank?}
  end
end
