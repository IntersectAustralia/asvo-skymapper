FactoryGirl.define do
  factory :point_query do |f|
    f.table_name "test_table"
    f.ra_column_name "test_ra_column"
    f.dec_column_name "test_dec_column"
    f.ra 90.0
    f.dec -1.0
    f.sr 1.0
  end
end