# Cài đặt Nginx Ingress Controller
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-basic"
  create_namespace = true

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }
}

# Cài đặt Cert-Manager (Quản lý chứng chỉ SSL)
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.13.2"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# Cài đặt External Secrets Operator (Kẻ đi lấy mật khẩu từ Azure Key Vault)
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  version          = "0.9.11" # Phiên bản ổn định hiện tại

  # Lệnh BẮT BUỘC để K8s học thêm các từ vựng CRD mới (SecretStore, ExternalSecret)
  set {
    name  = "installCRDs"
    value = "true"
  }
}