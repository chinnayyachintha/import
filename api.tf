# Create API Gateway REST API
resource "aws_api_gateway_rest_api" "website_dev" {
  name        = "Website-Dev-AD"
  description = "Website-Dev API"
}

# Create API Gateway resources
resource "aws_api_gateway_resource" "accessibility_request" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "accessibilityRequest"
}

resource "aws_api_gateway_resource" "search_ancillary" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "searchAncillary"
}

resource "aws_api_gateway_resource" "baggage" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "baggage"
}

resource "aws_api_gateway_resource" "create_reservation" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "createReservation"
}

resource "aws_api_gateway_resource" "flight_select" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "flightSelect"
}

resource "aws_api_gateway_resource" "low_fares" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "lowFares"
}

resource "aws_api_gateway_resource" "payment_methods" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "paymentMethods"
}

resource "aws_api_gateway_resource" "payment_reservation" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "paymentReservation"
}

resource "aws_api_gateway_resource" "seat_selection" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "seatSelection"
}

resource "aws_api_gateway_resource" "voucher_code" {
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  parent_id   = aws_api_gateway_rest_api.website_dev.root_resource_id
  path_part   = "voucherCode"
}

# Create Lambda Authorizer
resource "aws_api_gateway_authorizer" "custom_authorizer" {
  name               = "CustomLambdaAuthorizer"
  rest_api_id        = aws_api_gateway_rest_api.website_dev.id
  authorizer_uri     = aws_lambda_function.lambda_authorizer.invoke_arn
  identity_source    = "method.request.header.Authorization"
  type               = "REQUEST"
}

# Create API Gateway methods
resource "aws_api_gateway_method" "accessibility_request_get" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.accessibility_request.id
  http_method    = "GET"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

resource "aws_api_gateway_method" "search_ancillary_get" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.search_ancillary.id
  http_method    = "GET"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

resource "aws_api_gateway_method" "baggage_get" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.baggage.id
  http_method    = "GET"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

resource "aws_api_gateway_method" "create_reservation_post" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.create_reservation.id
  http_method    = "POST"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

resource "aws_api_gateway_method" "flight_select_get" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.flight_select.id
  http_method    = "GET"
  authorization  = "NONE"
}

resource "aws_api_gateway_method" "low_fares_get" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.low_fares.id
  http_method    = "GET"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

resource "aws_api_gateway_method" "payment_methods_get" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.payment_methods.id
  http_method    = "GET"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

resource "aws_api_gateway_method" "payment_reservation_post" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.payment_reservation.id
  http_method    = "POST"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

resource "aws_api_gateway_method" "seat_selection_get" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.seat_selection.id
  http_method    = "GET"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

resource "aws_api_gateway_method" "voucher_code_get" {
  rest_api_id    = aws_api_gateway_rest_api.website_dev.id
  resource_id    = aws_api_gateway_resource.voucher_code.id
  http_method    = "GET"
  authorization  = "CUSTOM"
  authorizer_id  = aws_api_gateway_authorizer.custom_authorizer.id
}

# Create API Gateway integrations
resource "aws_api_gateway_integration" "accessibility_request" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.accessibility_request.id
  http_method             = aws_api_gateway_method.accessibility_request_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.accessibilityRequest_Website_Dev.invoke_arn
}

resource "aws_api_gateway_integration" "search_ancillary" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.search_ancillary.id
  http_method             = aws_api_gateway_method.search_ancillary_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ancillarySearch.invoke_arn
}

resource "aws_api_gateway_integration" "baggage" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.baggage.id
  http_method             = aws_api_gateway_method.baggage_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.baggage.invoke_arn
}

resource "aws_api_gateway_integration" "create_reservation" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.create_reservation.id
  http_method             = aws_api_gateway_method.create_reservation_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.createReservation_Web_Dev.invoke_arn
}

resource "aws_api_gateway_integration" "flight_select" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.flight_select.id
  http_method             = aws_api_gateway_method.flight_select_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.flightSelection_dev_Web.invoke_arn
}

resource "aws_api_gateway_integration" "low_fares" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.low_fares.id
  http_method             = aws_api_gateway_method.low_fares_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lowFareoptions_Dev_Website.invoke_arn
}

resource "aws_api_gateway_integration" "payment_methods" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.payment_methods.id
  http_method             = aws_api_gateway_method.payment_methods_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.paymenthMethods.invoke_arn
}

resource "aws_api_gateway_integration" "payment_reservation" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.payment_reservation.id
  http_method             = aws_api_gateway_method.payment_reservation_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.reservationPaymentTransaction_dev_IHW.invoke_arn
}

resource "aws_api_gateway_integration" "seat_selection" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.seat_selection.id
  http_method             = aws_api_gateway_method.seat_selection_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.seatSealection.invoke_arn
}

resource "aws_api_gateway_integration" "voucher_code" {
  rest_api_id             = aws_api_gateway_rest_api.website_dev.id
  resource_id             = aws_api_gateway_resource.voucher_code.id
  http_method             = aws_api_gateway_method.voucher_code_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.voucherCode.invoke_arn
}

# Create API Gateway deployment
resource "aws_api_gateway_deployment" "website_dev" {
  depends_on = [
    aws_api_gateway_integration.accessibility_request,
    aws_api_gateway_integration.search_ancillary,
    aws_api_gateway_integration.baggage,
    aws_api_gateway_integration.create_reservation,
    aws_api_gateway_integration.flight_select,
    aws_api_gateway_integration.low_fares,
    aws_api_gateway_integration.payment_methods,
    aws_api_gateway_integration.payment_reservation,
    aws_api_gateway_integration.seat_selection,
    aws_api_gateway_integration.voucher_code
  ]
  rest_api_id = aws_api_gateway_rest_api.website_dev.id
  stage_name  = "dev"
}
