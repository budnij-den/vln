class User < ActiveRecord::Base
  validates :name, presence: true, on: :create
  validates :name, presence: true, on: :update
  validates :name, uniqueness: true, on: :create
  validates :name, uniqueness: true, on: :update
  validates :password, length: { in: 6..20 }, on: :create
  validates :password, length: { in: 6..20 }, on: :update
end
