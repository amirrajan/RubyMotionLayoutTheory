# How to run

If you are on the starter license, you'll need to comment out the following line in the Rakefile

```
app.deployment_target = '10.3'
```

Install these gems:

```
gem install rerun readline open3
```

Then run:

```
ruby auto-build.rb
```

Here are the devices you have access to:

To change to another device, just type into standard in
for the `ruby auto-build.rb` process. Any other command will
be redirected to the RM repl.

```
rake sim:ipad
rake sim:ipadair
rake sim:ipadpro11
rake sim:ipadpro12
rake sim:ipadpro9
rake sim:iphone11
rake sim:iphone11pro
rake sim:iphone11promax
rake sim:iphone5s
rake sim:iphone8
rake sim:iphone8plus
```
