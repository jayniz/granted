class CreateGrantedTable < ActiveRecord::Migration
  def self.foo
    :foo
  end
  def change
    create_table :grants do |t|
      t.integer :grantee_id
      t.string  :grantee_type
      t.integer :subject_id
      t.string  :subject_type
      t.string  :type

      t.timestamps
    end
  end
end
