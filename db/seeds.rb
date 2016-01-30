# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w(user admin).each do |role|
  Role.find_or_create_by(name: role)
end

Schema.find_or_create_by('name' => '2015 - Divadlo',
                         'x' => 23, 'y' => 12,
                         'capacity' => 23 * 12,
                         'constraint' => 15)

(1..12).each do |y|
  (1..23).each do |x|
    Seat.new('x' => x, 'y' => y, 'schema' => Schema.first,
             'state' => Seat::AVAILABLE, 'price' => 0).save!
  end
end
