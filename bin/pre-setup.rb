# This script creats the 'pizzabox-config' command that we rely on to know
# the options given to setup.rb when the package was built.
# 
# XXX Is there a better way to get that info in the build app at runtime?

require 'json'

File.open('pizzabox-config', 'w') do |f|
    f.write("#!/bin/sh\n# Generated at build time\n\ncat <<EOF\n")
    f.write(
        Hash[
            %w[prefix sysconfdir bindir rbdir].map {|k| [ k, config(k) ] }
        ].to_json
    )
    f.write("\nEOF\n")
end
