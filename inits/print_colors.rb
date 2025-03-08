def color_puts(text, color: :nil, background: :nil, style: :normal)
  colors = {
    black: 30, red: 31, green: 32, yellow: 33,
    blue: 34, magenta: 35, cyan: 36, white: 37
  }

  backgrounds = {
    black: 40, red: 41, green: 42, yellow: 43,
    blue: 44, magenta: 45, cyan: 46, white: 47
  }

  styles = {
    normal: 0, bold: 1, underline: 4, blink: 5
  }

  color_code = colors[color]
  bg_code = backgrounds[background]
  style_code = styles[style]
  options = [style_code, color_code, bg_code].compact.join(";")
  puts "\e[#{options}m#{text}\e[0m"
end
