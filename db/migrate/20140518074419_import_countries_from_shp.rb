class ImportCountriesFromShp < ActiveRecord::Migration[5.2]
  def up
    # USAGE: shp2pgsql [OPTIONS] shapefile [schema.]table
    # -c Creates a new table and populates it from the Shape file. This is the default mode.
    # -g geometry_column_name
    #     Specify the name of the geometry column to be (S) created (P) exported.
    # -W <encoding>
    #    Specify encoding of the input data (dbf file). When used, all attributes of the dbf
    #    are converted from the specified encoding to UTF8.
    # -s from_srid:to_srid
    #    If -s :to_srid is not specified then from_srid is assumed and no transformation happens.
    #from_shp_sql = `shp2pgsql -c -g geom -W LATIN1 -s 4326:3857 #{Rails.root.join('db', 'shpfiles', 'GAB_adm0.shp')} countries_ref`

    from_shp_sql = `shp2pgsql -c -g geom -W LATIN1 -s 4326 #{Rails.root.join('db', 'shpfiles', 'GAB_adm0.shp')} countries_ref`
    connection = ActiveRecord::Base.connection()

    # Country.transaction do
    #   execute from_shp_sql
    #
    #   execute <<-SQL
    #       insert into countries(name, iso_code, geom)
    #         select name_engli, iso, geom from countries_ref
    #   SQL
    #
    #   drop_table :countries_ref
    # end

    connection.execute from_shp_sql
    connection.execute <<-SQL
      insert into countries(name, iso_code, geom, created_at, updated_at)
        select name_engli, iso, geom, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from countries_ref
    SQL
    connection.execute "drop table countries_ref"
  end

  def down
    Country.delete_all
  end

end
