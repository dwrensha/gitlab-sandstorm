@0x9ec493829e8965ce;

using Spk = import "/sandstorm/package.capnp";
using Util = import "/sandstorm/util.capnp";

const pkgdef :Spk.PackageDefinition = (
  id = "zx9d3pt0fjh4uqrprjftgpqfwgzp6y2ena6098ug3ctv37uv6kfh",

  manifest = (

    appVersion = 2,  # Increment this for every release.
    appTitle = (defaultText = "GitLab"),
    appMarketingVersion = (defaultText = "2015.8.23 (7.8)"),

    metadata = (
      icons = (
        appGrid = (svg = embed "app-graphics/gitlab-128.svg"),
        grain = (svg = embed "app-graphics/gitlab-24.svg"),
        market = (svg = embed "app-graphics/gitlab-150.svg"),
       ),
       website = "https://about.gitlab.com/",
       codeUrl = "https://github.com/dwrensha/gitlab-sandstorm",
       license = (openSource = mit),
       categories = [developerTools,],
       author = (
         upstreamAuthor = "GitLab Inc.",
         contactEmail = "david@sandstorm.io",
         pgpSignature = embed "pgp-signature",
       ),
       pgpKeyring = embed "pgp-keyring",
       description = (defaultText = embed "description.md"),
       shortDescription = (defaultText = "Git hosting"),
       screenshots = [(width = 448, height = 281, png = embed "screenshot.png")],
       changeLog = (defaultText = embed "changeLog.md"),
     ),

    actions = [
      ( title = (defaultText = "New GitLab Repository"),
        nounPhrase = (defaultText = "repository"),
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
                     "gitlab/.bundle/ruby/2.1.0/cache",
                     "gitlab/app/controllers/oauth",
                     ]
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

  alwaysInclude = ["gitlab/vendor", "gitlab/.bundle", "gitlab/app", "gitlab/config", "gitlab/public",
                   "gitlab/read-only-cache",
                   "gitlab-shell/hooks", "gitlab-shell/lib",
                   "usr/bin/node"],

  bridgeConfig = (
    viewInfo = (
       permissions = [(name = "owner", title = (defaultText = "owner"),
                       description =
                        (defaultText = "A vestigal permission only useful outside of Sandstorm.")),
                      (name = "master", title = (defaultText = "master"),
                       description = (defaultText = "A master can push to any branch.")),
                      (name = "developer", title = (defaultText = "developer"),
                       description = (defaultText = "A developer can create merge requests.")),
                      (name = "reporter", title = (defaultText = "reporter"),
                       description =
                        (defaultText = "A reporter can view the code and manage the issue tracker.")),
                      (name = "guest", title = (defaultText = "guest"),
                      description = (defaultText = "A guest can create new issues and leave comments."))
                      ],
       roles = [
                (title = (defaultText = "master"),
                 verbPhrase = (defaultText = "can push to any branch"),
                 permissions = .masterPermissions,
                 default = true),
                (title = (defaultText = "developer"),
                 verbPhrase = (defaultText = "can create merge requests"),
                 permissions = .developerPermissions),
                (title = (defaultText = "reporter"),
                 verbPhrase = (defaultText = "can view and pull code"),
                 permissions = .reporterPermissions),
                (title = (defaultText = "guest"),
                 verbPhrase = (defaultText = "can create new issues"),
                 permissions = .guestPermissions)
                ]

    )
  )

);

#                                        admin, master, dev,  report, guest
const ownerPermissions     :List(Bool) = [true,   true,  true,  true,  true];
const masterPermissions    :List(Bool) = [false,  true,  true,  true,  true];
const developerPermissions :List(Bool) = [false, false,  true,  true,  true];
const reporterPermissions  :List(Bool) = [false, false, false,  true,  true];
const guestPermissions     :List(Bool) = [false, false, false, false,  true];

const commandEnvironment : List(Util.KeyValue) =
  [
    (key = "PATH", value = "/usr/local/rbenv/versions/2.1.6/bin:/usr/local/bin:/usr/bin:/bin"),
    (key = "HOME", value = "/home/git")
  ];

const startCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "10000", "--", "/bin/sh", "start.sh"],
  environ = .commandEnvironment
);

const continueCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "10000", "--", "/bin/sh", "continue.sh"],
  environ = .commandEnvironment
);
