class DeleteCommentsWithoutOwner < ActiveRecord::Migration
  def change
    execute <<-SQL
      DELETE FROM comments WHERE comments.id IN (
        SELECT id FROM comments WHERE owner_id NOT IN (SELECT id from users)
      )
    SQL
  end
end
