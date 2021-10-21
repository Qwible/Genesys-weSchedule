# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, "https://www.gstatic.com/"
  policy.script_src :self, :unsafe_inline, :unsafe_eval, "https://www.gstatic.com/"
  policy.style_src :self, :unsafe_inline, "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/", "https://www.gstatic.com/"
  policy.img_src :self, "https://i.imgur.com/hF8YUxy.png", "https://assets-global.website-files.com/",
  "https://www.qualtrics.com/", " https://www.marinasmediterraneo.com/marinaseste/wp-content/uploads/sites/4/2018/09/generic-user-purple-4.png",
  "https://wallpaperaccess.com/full/95257.png", "https://www.okendo.io/icons/check.svg",
  "https://www.pinclipart.com/picdir/big/11-119222_thumbs-up-icon-green-th-clip-art-green.png",
  "http://www.clker.com/cliparts/5/2/5/8/13476359851958638477thumbs-down-icon-red-hi-md.png",
  "https://i.imgur.com/dNsGkcL.png",
  "https://i.imgur.com/23kPPzK.png", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvloFEJ54ZozFEYImNaH_csYbLxQPDL8DqBw&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJyYGHZIBJuaheYJVYkNOpn8ZNmFJ6hZbS2Q&usqp=CAU",
  "https://icon-library.com/images/free-map-icon/free-map-icon-9.jpg", "https://icon-library.com/images/feedback-icon/feedback-icon-18.jpg",
  "https://i.imgur.com/23kPPzK.png",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvloFEJ54ZozFEYImNaH_csYbLxQPDL8DqBw&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJyYGHZIBJuaheYJVYkNOpn8ZNmFJ6hZbS2Q&usqp=CAU",
  "https://icon-library.com/images/free-map-icon/free-map-icon-9.jpg",
  "https://icon-library.com/images/feedback-icon/feedback-icon-18.jpg",
  "https://icon-library.com/images/register-icon-png/register-icon-png-8.jpg",
  "https://icon-library.com/images/people-circle-icon/people-circle-icon-7.jpg",
  "https://free-icon-rainbow.com/i/icon_00500/icon_005000_256.jpg",
  "https://cdn0.iconfinder.com/data/icons/tuts/256/shareit.png",
  "https://cdn0.iconfinder.com/data/icons/tuts/256/shareit.png",
  "https://i.imgur.com/E1sFZr3.png",
  "https://i.pinimg.com/originals/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.png",
  "https://s3.amazonaws.com/qualtrics-www/arrow-white.svg"
  policy.font_src :self, "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/"
end
#   # If you are using webpack-dev-server then specify webpack-dev-server host
#   policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?

#   # Specify URI for violation reports
#   # policy.report_uri "/csp-violation-report-endpoint"
# end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
