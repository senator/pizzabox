# This script creats the 'pizzabox-config' command that we rely on to know
# the options given to setup.rb when the package was built.
# 
# XXX Is there a better way to get that info in the build app at runtime?

require 'pathname'

src = Pathname.new(srcdir_root) + "binsuppl/pizzabox-config.pre"
dst = 'pizzabox-config'

raise "BUILD FAIL: #{src} does not exist (srcdir_root: #{srcdir_root}" \
    unless File.exist?(src)

replacements = %w[prefix sysconfdir bindir rbdir].map do |key|
    "s!@@#{key}@@!" + config(key) + "!"
end.join("; ")

system("sed -e '#{replacements}' #{src} > #{dst}")
