package com.shop.servlet;

import com.shop.dao.ProductDAO;
import com.shop.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/product")
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/catalog");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            Product product = productDAO.findById(productId);

            if (product == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Товар не найден");
                return;
            }

            req.setAttribute("product", product);
            req.getRequestDispatcher("/WEB-INF/views/product.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Ошибка при загрузке товара", e);
        }
    }
}