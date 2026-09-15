sudo snap install helm --classic
# OR
HELM_BUILDKITE_APT_KEY_ID="DDF78C3E6EBB2D2CC223C95C62BA89D07698DBC6"

sudo apt-get install curl gpg apt-transport-https --yes

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey > "${TMPDIR:-/tmp}/helm.gpg"

# Ensure that the key ID matches to prevent a repository compromise from establishing an attacker controlled key
if [ "$(gpg --show-keys --with-colons "${TMPDIR:-/tmp}/helm.gpg" | awk -F: '$1 == "fpr" {print $10}' | head -n 1)" != "${HELM_BUILDKITE_APT_KEY_ID}" ]; then echo "ERROR: Unexpected Helm APT key ID: potential key compromise"; exit 1; fi

cat "${TMPDIR:-/tmp}/helm.gpg" | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update
sudo apt-get install helm -y
values.yaml

###
# artifacthub.io
helm install <release-name> <chart-name>
helm install my-site bitnami/wordpress

# Helm chart structure
chart-directory
.. templates (folder)
.. values.yaml
.. Chart.yaml
.. LICENSE
.. README.md

helm --help
helm repo --help
# Install app with helm
1. search for app in repositories. The first is preferred. Or use artifacthub.io
helm search hub wordpress  # all repositories are listed

# Note this among the results: https://artifacthub.io/packages/helm/bitnami/wo...

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo list
helm search repo wordpress  # searches only installed repo(s)
help install my-release bitnami/wordpress
# To customize:
helm install --set wordpressBlogName="Helm Tutorials" --set wordpressEmail="john@example.com" my-release bitnami/wordpress
#OR create custom-values.yaml
wordpressBlogName: Helm Tutorials
wordpressEmail: john@example.com
helm install --values=custom-values.yaml my-release bitnami/wordpress

# More complicated:
helm pull bitnami/wordpress
OR
helm pull --untar bitnami/wordpress
cd wordpress
kate values.yaml  # then edit
cd ..
helm install my-release ./wordpress
