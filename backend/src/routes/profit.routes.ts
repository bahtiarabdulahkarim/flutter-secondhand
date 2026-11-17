import { Router } from "express";
import { prisma } from "../config/database.js";
import {
  verifyFirebaseToken,
  authorizeRoles,
} from "../middlewares/auth.middleware.js";

const router = Router();

// GET /api/v1/profit/summary
router.get(
  "/profit/summary",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
  try {
    const transactions = await prisma.transactions.findMany({
      where: {
        status: "completed",
      },
      include: {
        transaction_items: true,
      },
      orderBy: {
        transaction_date: "desc",
      },
    });

    let totalSales = 0;
    let totalHpp = 0;
    let totalDiscount = 0;

    let incompleteHppTransactions = 0;
    let incompleteHppItems = 0;

    const vehicleProfits: any[] = [];

    for (const transaction of transactions) {
      totalSales += Number(transaction.total_amount);
      totalDiscount += Number(transaction.discount);

      const items = transaction.transaction_items;

      const itemDiscountTotal = items.reduce(
        (total, item) =>
          total + Number(item.discount_amount),
        0
      );

      // Diskon transaksi di luar diskon masing-masing item
      const transactionLevelDiscount = Math.max(
        0,
        Number(transaction.discount) - itemDiscountTotal
      );

      const subtotal = items.reduce(
        (total, item) =>
          total + Number(item.sale_price),
        0
      );

      let remainingDiscount = transactionLevelDiscount;
      let transactionHasIncompleteHpp = false;

      for (let i = 0; i < items.length; i++) {
        const item = items[i];

        const acquisitionCost = Number(
          item.acquisition_cost_snapshot
        );

        const repairCost = Number(
          item.repair_cost_snapshot
        );

        const otherCost = Number(
          item.other_cost_snapshot
        );

        const hpp =
          acquisitionCost + repairCost + otherCost;

        // Acquisition wajib tercatat sebagai dasar HPP
        const isHppComplete = acquisitionCost > 0;

        if (isHppComplete) {
          totalHpp += hpp;
        } else {
          incompleteHppItems++;
          transactionHasIncompleteHpp = true;
        }

        const salePrice = Number(item.sale_price);
        const itemDiscount = Number(item.discount_amount);

        // Alokasi diskon transaksi secara proporsional
        let allocatedDiscount = 0;

        if (subtotal > 0 && transactionLevelDiscount > 0) {
          if (i === items.length - 1) {
            allocatedDiscount = remainingDiscount;
          } else {
            allocatedDiscount =
              Math.round(
                (
                  transactionLevelDiscount *
                  salePrice /
                  subtotal
                ) * 100
              ) / 100;

            allocatedDiscount = Math.min(
              allocatedDiscount,
              remainingDiscount
            );
          }
        }

        remainingDiscount =
          Math.round(
            (remainingDiscount - allocatedDiscount) * 100
          ) / 100;

        const netSalePrice =
          salePrice - itemDiscount - allocatedDiscount;

        vehicleProfits.push({
          transaction_id: transaction.id.toString(),
          transaction_date: transaction.transaction_date,
          vehicle_id: item.vehicle_id.toString(),
          vehicle_title: item.vehicle_title_snapshot,
          vehicle_code: item.vehicle_code_snapshot,

          sale_price: salePrice,
          item_discount: itemDiscount,
          allocated_transaction_discount: allocatedDiscount,
          net_sale_price: netSalePrice,

          acquisition_cost: acquisitionCost,
          repair_cost: repairCost,
          other_cost: otherCost,

          total_hpp: isHppComplete ? hpp : null,

          hpp_status: isHppComplete
            ? "complete"
            : "incomplete",

          gross_profit: isHppComplete
            ? netSalePrice - hpp
            : null,
        });
      }

      if (transactionHasIncompleteHpp) {
        incompleteHppTransactions++;
      }
    }

    const hasIncompleteHpp = incompleteHppItems > 0;

    const grossProfit = hasIncompleteHpp
      ? null
      : totalSales - totalHpp;

    return res.status(200).json({
      success: true,
      message: "Laporan profit berhasil diambil",
      data: {
        total_transactions: transactions.length,
        total_sales: totalSales,
        total_discount: totalDiscount,

        total_hpp: hasIncompleteHpp
          ? null
          : totalHpp,

        recorded_hpp: totalHpp,

        gross_profit: grossProfit,

        incomplete_hpp_transactions:
          incompleteHppTransactions,

        incomplete_hpp_items:
          incompleteHppItems,

        hpp_report_status: hasIncompleteHpp
          ? "incomplete"
          : "complete",

        vehicle_profits: vehicleProfits,
      },
    });
  } catch (error) {
    console.error("GET PROFIT SUMMARY ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal mengambil laporan profit",
    });
  }
});

export default router;
