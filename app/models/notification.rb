class Notification < ApplicationRecord
  belongs_to :micropost, optional: true
  belongs_to :visiter, class_name: 'User'
  belongs_to :visited, class_name: 'User'
end
