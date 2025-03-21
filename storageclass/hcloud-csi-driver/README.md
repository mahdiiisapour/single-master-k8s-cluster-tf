# Helm Chart for hcloud-csi-driver

This is a community Helm Chart for installing the hcloud-csi-driver in your Hetzner Cloud Kubernetes cluster.
The original sources of the hcloud-csi-driver can be found at
[https://github.com/hetznercloud/csi-driver](https://github.com/hetznercloud/csi-driver).

**Please note**: This project is a community project from a Hetzner customer, published for use by other Hetzner customers.
Neither the author nor this project is affiliated with Hetzner Online GmbH.


## Installation

### Add Helm Repository

```
helm repo add mlohr https://helm-charts.mlohr.com/
helm repo update
```

### Install to Kubernetes

In order to install the hcloud-csi-driver successfully, you have to provide a [Hetzner API Token](https://wiki.hetzner.de/index.php/API_access_token),
which will reside in a Secret resource within Kubernetes.
For installing this Helm Chart, you can either reuse an existing secret (e.g. from [hcloud-cloud-controller-manager Helm Chart](https://gitlab.com/MatthiasLohr/hcloud-cloud-controller-manager-helm-chart)) or create a new one.

  * Install without reusing an existing secret:
    ```
    helm install -n kube-system hcloud-csi-driver mlohr/hcloud-csi-driver \
      --set secret.hcloudApiToken=<HCLOUD API TOKEN>
    ```
  * Install reusing an existing secret:
    ```
    helm install -n kube-system hcloud-csi-driver mlohr/hcloud-csi-driver \
      --set secret.existingSecretName=<EXISTING SECRET NAME>
    ```


## Configuration

To see all available configuration options for a deployment using this helm chart,
please check the [`values.yaml`](https://gitlab.com/MatthiasLohr/hcloud-csi-driver-helm-chart/-/blob/main/values.yaml) file.


## License

This project is published under the Apache License, Version 2.0.
See [LICENSE.md](https://gitlab.com/MatthiasLohr/hcloud-cloud-controller-manager-helm-chart/-/blob/master/LICENSE.md) for more information.

Copyright (c) by [Matthias Lohr](https://mlohr.com/) &lt;[mail@mlohr.com](mailto:mail@mlohr.com)&gt;
