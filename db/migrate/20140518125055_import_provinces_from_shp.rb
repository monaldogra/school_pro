class ImportProvincesFromShp < ActiveRecord::Migration[5.2]
  def up
    from_shp_sql = `shp2pgsql -c -g geom -W LATIN1 -s 4326 #{Rails.root.join('db', 'shpfiles', 'GAB_adm1.shp')} provinces_ref`
    connection = ActiveRecord::Base.connection()
    # Province.transaction do
    #   execute from_shp_sql
    #
    #   execute <<-SQL
    #       insert into provinces(name, geom)
    #         select name_1, geom from provinces_ref
    #   SQL
    #
    #   drop_table :provinces_ref
    # end
    connection.execute from_shp_sql
    connection.execute <<-SQL
      insert into provinces(name, geom, created_at, updated_at)
        select name_1, geom, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from provinces_ref
    SQL
    connection.execute "drop table provinces_ref"

  end

  def down
    Province.delete_all
  end
end
