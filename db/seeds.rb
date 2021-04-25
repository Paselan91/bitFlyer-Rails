# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create name: "testBitflyer"

BtcCandle.create(
    ProductCode: 'JPY',
    Duration: '1s',
    Time: Time.now,
    Open: 1.11,
    Close: 2.22,
    High: 3.33,
    Low: 4.44,
    Volume: 5.55
)
