# 1. Tự động cài Cert-Manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.13.2" # Nên khóa cứng version ở Production
  values           = [yamlencode({
    installCRDs = true
  })]

  # Bắt buộc phải đợi cụm AKS tạo xong thì mới được cài Helm
  depends_on = [module.aks]
}

# 2. (Tùy chọn) Tự động cài Nginx Ingress Controller
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-basic"
  create_namespace = true
  
  depends_on = [module.aks]
}