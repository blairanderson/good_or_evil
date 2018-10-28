class CreateArticles < ActiveRecord::Migration
  def change

    create_table :sources do |t|
      t.text :title
      t.string :host
      t.string :feed_url
      t.text :image
      t.text :description

      t.timestamps null: false
    end

    create_table :subjects do |t|
      t.text :title
      t.text :image
      t.text :description
      t.integer :page_views, default: 0, null: false

      t.timestamps null: false
    end

    create_table :articles do |t|
      t.references :source, index: true, foreign_key: true
      t.text :title
      t.text :url
      t.datetime :published_at
      t.text :image
      t.string :author
      t.json :categories, default: []
      t.text :summary


      t.timestamps null: false
    end

    create_table :article_subjects do |t|
      t.references :article, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :article_page_views do |t|
      t.references :article, index: true, foreign_key: true
      t.date :page_view_date, null: false
      t.integer :page_views, default: 0, null: false

      t.timestamps null: false
    end

    create_table :subject_page_views do |t|
      t.references :subject, index: true, foreign_key: true
      t.date :page_view_date, null: false
      t.integer :page_views, default: 0, null: false

      t.timestamps null: false
    end

    add_index :subject_page_views, [:subject_id, :page_view_date], unique: true, order: { page_view_date: "DESC" }
    add_index :article_page_views, [:article_id, :page_view_date], unique: true, order: { page_view_date: "DESC" }
    add_index :sources, :url, unique: true
    add_index :articles, :url, unique: true
  end
end



