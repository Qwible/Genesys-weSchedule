module UtcDay
    def self.get_current_utc_day
        now = Time.now.to_f
        day = (now / (24 * 60 * 60)).floor
        return day
    end
end