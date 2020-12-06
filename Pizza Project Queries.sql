USE `PizzaRetailerProject`;

-- QUERY 1
-- Number of the times a product is ordered.
SELECT products.ProductID, COUNT(order_product.ProductID) AS `Times the product is ordered`
FROM products, order_product
WHERE products.ProductID= order_product.ProductID 
GROUP BY order_product.ProductID
ORDER BY `Times the product is ordered` DESC;

-- QUERY 2
-- Number of times a product appears in a menu (How many of a product you will have if you order all the menus once)
SELECT products.ProductID, sum(menu_product.Quantity) AS `Times a product appears in a menu`
FROM menu_product 
LEFT JOIN products ON products.ProductID=menu_product.MenuItemProductID
GROUP BY products.ProductID
ORDER BY `Times a product appears in a menu` DESC
;

-- QUERY 3
-- IDs of Customers that have at least one order that costs more than 40 TRY
SELECT DISTINCT Orders.CustomerID AS `Customers with at least one order that costs more than 40 TRY`
FROM Orders, order_product, products
WHERE ORDERS.OrderID = order_product.OrderID
AND order_product.ProductID = products.ProductID
GROUP BY ORDERS.OrderID
HAVING SUM(products.unitprice) > 40
;

-- QUERY 4
-- Total amount a customer paid to pick-up discounted orders.

SELECT orders.CustomerID, SUM(products.UnitPrice)*(1-discounts.Percentage) AS `Total Cost`
FROM orders, order_product, products, discounts
WHERE order_product.ProductID = products.ProductID AND orders.OrderID = order_product.OrderID
AND orders.DeliveryTypeID = 'DE2' AND discounts.DiscountID = 'DSC99'
GROUP BY orders.CustomerID
;

-- QUERY 5
-- Calculate the price of the custom pizzas without using "Products" table.

SELECT custom_pizza.ProductID, (thickness_price.Price + mainingredients_price.Price + sum(topping_price.Price)) AS `Price of Custom Pizza`
FROM custom_pizza, pizzas, thickness_price, mainingredients_price, pizza_topping, topping_price
WHERE pizzas.ProductID = custom_pizza.ProductID
AND pizzas.ThicknessID = thickness_price.ThicknessID
AND custom_pizza.SizeID = thickness_price.SizeID
AND pizzas.MainIngredientID = mainingredients_price.MainIngredientID
AND pizza_topping.ToppingID = topping_price.ToppingID
AND pizza_topping.ProductID = custom_pizza.ProductID
AND topping_price.SizeID = custom_pizza.SizeID
GROUP BY custom_pizza.ProductID
;
