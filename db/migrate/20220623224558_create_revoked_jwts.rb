class CreateRevokedJwts < ActiveRecord::Migration[7.0]
  def change
    create_table :revoked_jwts do |t|
      t.string :value, null: false
      t.timestamps
    end
  end
end
