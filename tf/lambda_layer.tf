resource "aws_lambda_layer_version" "lambda_scrobbler_dependencies" {
  layer_name          = local.lambda_scrobbler_layer_name
  filename            = data.archive_file.lambda_scrobbler_layer.output_path
  source_code_hash    = data.archive_file.lambda_scrobbler_layer.output_base64sha256
  compatible_runtimes = ["python3.11"]
  description         = "Python dependencies for ${var.project_name}."
}

data "archive_file" "lambda_scrobbler_layer" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/layer"
  output_path = "${path.module}/lambda/layer.zip"

  depends_on = [null_resource.pip_install]
}

resource "null_resource" "pip_install" {
  triggers = {
    requirements = filemd5("${path.module}/../pyproject.toml")
  }

  provisioner "local-exec" {
    command = "cd ${path.module}/lambda && ./build_layer.sh"
  }
}
