@0x9ec493829e8965ce;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "zx9d3pt0fjh4uqrprjftgpqfwgzp6y2ena6098ug3ctv37uv6kfh",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appVersion = 0,  # Increment this for every release.

    actions = [
      ( title = (defaultText = "New GitLab Repository"),
        command = .startCommand
      )
    ],

    continueCommand = .continueCommand
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( sourcePath = ".", # Search this directory first.
        hidePaths = ["gitlab/.git", ".git",
                     "gitlab/vendor/bundle/ruby/2.1.0/cache",
                     "gitlab/app/controllers/oauth",
                     "gitlab/app/models/project_services"]
      ),
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = ["home", "proc", "sys", "etc/nsswitch.conf", "etc/localtime",
                     "etc/host.conf", "etc/resolv.conf",
                     "usr/bin/ruby"
                        ]
      )
    ]
  ),

  fileList = "sandstorm-files.list",

  alwaysInclude = ["gitlab/vendor", "gitlab/app", "gitlab/config", "gitlab/public",
                   "gitlab/tmp",
                   "gitlab-shell/vendor", "gitlab-shell/hooks", "gitlab-shell/lib"],

  bridgeConfig = (
    viewInfo = (
       permissions = [(name = "admin")]
    )
  )

);

const startCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "10000", "--", "/bin/bash", "start.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "HOME", value = "/home/git")
  ]
);

const continueCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "10000", "--", "/bin/bash", "continue.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "HOME", value = "/home/git")
  ]
);
