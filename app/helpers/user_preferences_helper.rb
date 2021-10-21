module UserPreferencesHelper
  def self.convert_time_string_to_int(str)
    split = str.split(':')
    value = (split[0].to_i*60 + split[1].to_i)*60
    return value
  end

  def self.convert_time_int_to_string(n)
    hour = n/(60.0**2).floor
    min = (n - hour * 60 * 60)/60
    string = '%02d:%02d' % [hour, min]
    return string
  end
end
