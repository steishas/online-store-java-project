package com.shop.servlet;

import com.shop.dao.CategoryDAO;
import com.shop.dao.ProductDAO;
import com.shop.model.Category;
import com.shop.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/catalog")
public class CatalogServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    private static final int PAGE_SIZE = 12; // Товаров на странице

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String categoryIdParam = req.getParameter("categoryId");
        String pageParam = req.getParameter("page");

        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

        int offset = (currentPage - 1) * PAGE_SIZE;

        try {
            // Получаем список категорий для меню
            List<Category> categories = categoryDAO.findAll();
            req.setAttribute("categories", categories);

            // Получаем товары и общее количество
            List<Product> products;
            int totalProducts;
            int totalPages;

            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                int categoryId = Integer.parseInt(categoryIdParam);
                products = productDAO.findPaginatedByCategory(categoryId, offset, PAGE_SIZE);
                totalProducts = productDAO.countProductsByCategory(categoryId);
                totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
                req.setAttribute("selectedCategoryId", categoryId);
            } else {
                products = productDAO.findPaginated(offset, PAGE_SIZE);
                totalProducts = productDAO.countProducts();
                totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
            }

            req.setAttribute("products", products);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalProducts", totalProducts);

            req.getRequestDispatcher("/WEB-INF/views/catalog.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Ошибка при загрузке каталога", e);
        }
    }
}