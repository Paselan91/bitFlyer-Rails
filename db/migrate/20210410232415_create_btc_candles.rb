class CreateBtcCandles < ActiveRecord::Migration[6.0]
  def change
    create_table :btc_candles do |t|
      t.string :ProductCode
      t.string :Duration
      t.time   :Time
      t.float :Open
      t.float :Close
      t.float :High
      t.float :Low
      t.float :Volume
      t.timestamps
    end
  end
end


  # ProductCode string        `json:"productCode" gorm:"not null"`
	# Duration    time.Duration `json:"duration" gorm:"not null"`
	# Time        time.Time     `json:"time" gorm:"not null"`
	# Open        float64       `json:"open" gorm:"not null"`
	# Close       float64       `json:"close" gorm:"not null"`
	# High        float64       `json:"high" gorm:"not null"`
	# Low         float64       `json:"low" gorm:"not null"`
	# Volume      float64       `json:"volume" gorm:"not null"`
