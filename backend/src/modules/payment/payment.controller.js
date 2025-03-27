const PaymentService = require("./payment.service");
const Order = require("../order/order.model");
const ApiResponse = require("../../utils/response");

class PaymentController {
  async createPayment(req, res) {
    try {
      const userId = req.userId;
      const { orderId, paymentType } = req.body;
      if (!orderId || !paymentType) {
        return ApiResponse.error(
          res,
          "Missing required fields",
          [
            {
              code: "MISSING_FIELDS",
              detail: "orderId and paymentType are required",
            },
          ],
          400
        );
      }

      const payment = await PaymentService.createPayment(
        userId,
        orderId,
        paymentType
      );
      const responseData = {
        id: payment._id,
        order: payment.order,
        transactionId: payment.transactionId,
        paymentType: payment.paymentType,
        amount: payment.amount,
        status: payment.status,
        paymentUrl: payment.paymentUrl,
        paymentDate: payment.paymentDate,
        createdAt: payment.createdAt,
      };
      return ApiResponse.success(
        res,
        responseData,
        "Payment created successfully",
        null,
        201
      );
    } catch (error) {
      const statusCode =
        error.message.includes("not found") || error.message.includes("owned")
          ? 404
          : error.message.includes("exists") ||
            error.message.includes("processed") ||
            error.message.includes("amount")
          ? 400
          : 500;
      const errorCode =
        error.message.includes("not found") || error.message.includes("owned")
          ? "ORDER_NOT_FOUND"
          : error.message.includes("exists")
          ? "PAYMENT_EXISTS"
          : error.message.includes("processed")
          ? "ORDER_PROCESSED"
          : error.message.includes("amount")
          ? "INVALID_AMOUNT"
          : "INTERNAL_SERVER_ERROR";
      return ApiResponse.error(
        res,
        error.message,
        [{ code: errorCode, detail: error.message }],
        statusCode
      );
    }
  }

  async handlePaymentCallback(req, res) {
    try {
      const payment = await PaymentService.handlePaymentCallback(req.body);
      const responseData = {
        id: payment._id,
        order: payment.order,
        transactionId: payment.transactionId,
        status: payment.status,
        updatedAt: payment.updatedAt,
      };
      return ApiResponse.success(
        res,
        responseData,
        "Payment callback processed successfully"
      );
    } catch (error) {
      const statusCode = error.message.includes("not found") ? 404 : 500;
      const errorCode = error.message.includes("not found")
        ? "PAYMENT_NOT_FOUND"
        : "INTERNAL_SERVER_ERROR";
      return ApiResponse.error(
        res,
        error.message,
        [{ code: errorCode, detail: error.message }],
        statusCode
      );
    }
  }

  async getPayment(req, res) {
    try {
      const userId = req.userId;
      const { orderId } = req.params;
      const payment = await PaymentService.getPayment(orderId, userId);
      const responseData = {
        id: payment._id,
        order: {
          id: payment.order._id,
          total: payment.order.total,
          status: payment.order.status,
          shippingAddress: payment.order.shippingAddress,
        },
        transactionId: payment.transactionId,
        paymentType: payment.paymentType,
        amount: payment.amount,
        status: payment.status,
        paymentUrl: payment.paymentUrl,
        paymentDate: payment.paymentDate,
        createdAt: payment.createdAt,
        updatedAt: payment.updatedAt,
      };
      return ApiResponse.success(
        res,
        responseData,
        "Payment retrieved successfully"
      );
    } catch (error) {
      const statusCode = error.message.includes("not found") ? 404 : 500;
      const errorCode = error.message.includes("not found")
        ? "PAYMENT_NOT_FOUND"
        : "INTERNAL_SERVER_ERROR";
      return ApiResponse.error(
        res,
        error.message,
        [{ code: errorCode, detail: error.message }],
        statusCode
      );
    }
  }
}

module.exports = new PaymentController();
