class Line < ActiveRecord::Base
  validates :author, presence: true     #провал валидации означает три пустых поля (автор, название, год). доработать div/popup/alert о неоставлении этого поля пустым
end
