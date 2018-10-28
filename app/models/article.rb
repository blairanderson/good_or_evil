class Article < ActiveRecord::Base
  belongs_to :source
  belongs_to :subject
end
