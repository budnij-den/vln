class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.text :name, :email, :password
      t.boolean :is_admin, default: false
      t.timestamps
    end
  User.create name: 'admin', email: 'budden@list.ru', password: 'secret', is_admin: true
  User.create name: 'not_admin', email: 'suvolokindn@yandex.ru', password: 'not_secret'
  end
end
