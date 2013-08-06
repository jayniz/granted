class CreateGrants < ActiveRecord::Migration
  def self.filename
    __FILE__
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

    add_index :grants, [:grantee_id, :grantee_type, :subject_id, :subject_type, :type], unique: true, name: :grants_uniqueness
  end
end
