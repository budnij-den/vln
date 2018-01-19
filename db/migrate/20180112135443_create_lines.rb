class CreateLines < ActiveRecord::Migration[5.1]
  def change
    create_table :lines do |t|
      t.text :author, :title, :year, :tags, :comment, :character, :creator
      t.boolean :spent_bul, default: false
      t.timestamps
    end
    Line.create author: 'George Orwell', title: 'Nineteen Eighty-Four', year: '1949', character: 'book', creator: 'admin'
    Line.create author: 'Урсула Ле Гуин', title: 'Планета Изгнания', year: '1966', character: 'book', spent_bul: true, creator: 'admin'
    Line.create author: 'Martin Scorsese', title: 'Goodfellas', year: '1990', character: 'movie', creator: 'admin'
    Line.create author: 'Luc Besson', title: 'Leon', year: '1994', character: 'movie', spent_bul: true, creator: 'admin'
    Line.create author: 'George Orwell', title: 'Nineteen Eighty-Four', year: '1949', character: 'book', creator: 'not_admin'
    Line.create author: 'Урсула Ле Гуин', title: 'Планета Изгнания', year: '1966', character: 'book', spent_bul: true, creator: 'not_admin'
    Line.create author: 'Martin Scorsese', title: 'Goodfellas', year: '1990', character: 'movie', creator: 'not_admin'
    Line.create author: 'Luc Besson', title: 'Leon', year: '1994', character: 'movie', spent_bul: true, creator: 'not_admin'
  end
end
