# aws-cli-installer

Download and install self-contained AWS CLI v2 on a Linux host machine.

## Usage

`unzip` and either `curl` or `wget` are required.

```bash
# Download the installer script (via whatever means)
wget https://raw.githubusercontent.com/sapslaj/aws-cli-installer/main/aws-cli-installer

# run the installer with sudo (if using the default install prefix)
sudo aws-cli-installer
```

By default, AWS CLI is installed to `/opt/aws-cli` Symlinks are created in
`/usr/local/bin/` for executables.

```plain
Usage: aws-cli-installer [OPTIONS]

Options:
    -h, --help          Display this message
    -v, --version <version>
                        Specify AWS CLI version to install
    -i, --install-dir <path>
                        The directory to install the AWS CLI v2. By default,
                        this directory is /opt/aws-cli
    -b, --bin-dir <path>
                        The directory to store symlinks to executables for the
                        AWS CLI v2. By default, this directory is
                        /usr/local/bin
    -k, --keep-tmp      Keep temporary files in current directory
    -g, --gpg-check     Verify signature with GPG
    --gpg-autoimport    Automatically import the AWS CLI Team's GPG key
    -u, --uninstall     Uninstall AWS CLI
```

See `aws-cli-installer --help` for the most up-to-date options.

### GPG

This script includes support for verifying the signature of the awscli bundle
using GnuPG using the `--gpg-check` flag. Using this flag alone, the [PGP
public key from the AWS CLI
team](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-version.html)
must be imported before this script is run. Using the additional
`--gpg-autoimport` flag will import an inline copy of the public key. I
recommend using the `--gpg-autoimport` judiciously as the key may change at any
time without your (or my) knowledge.

## Why

This script is intended to replace all of the manual steps for Linux on the
[Install or update to the latest version of the AWS
CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
documentation page. In addition to downloading (and optionally verifying) the
AWS CLI package, it also installs it in a more sane way compared to the one
shipped by default.

[AWS refuses to publish v2 to
PyPI](https://github.com/aws/aws-cli/issues/4947). In addition they haven't
gotten around to providing any kind of reasonable package other than "download
a zip file and run this installer script." On the other hand, distro package
managers lose their minds over the amount of vendored stuff and either refuse
to even attempt packaging it or try to un-bundle everything which cause weird
breakages.

So with the only stable way of installing AWS CLI v2 requiring quite a bit of
extra work (along with the included installer script being... not great) makes
_automating_ AWS CLI v2 installation a pain. So this script is a middle ground.
