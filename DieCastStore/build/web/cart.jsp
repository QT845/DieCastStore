<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart</title>
        <script>
            // Tính tổng tiền của các sản phẩm được chọn
            function updateSelectedTotal() {
                var checkboxes = document.querySelectorAll('.item-checkbox:checked');
                var total = 0;
                var selectedCount = 0;

                checkboxes.forEach(function (checkbox) {
                    var row = checkbox.closest('tr');
                    var subtotalCell = row.querySelector('.subtotal');
                    var subtotal = parseFloat(subtotalCell.textContent.replace('$', '').replace(',', ''));
                    total += subtotal;
                    selectedCount++;
                });

                document.getElementById('selectedTotal').textContent = total.toFixed(2) + ' $';
                document.getElementById('selectedCount').textContent = selectedCount;

                // Enable/disable checkout button
                var checkoutBtn = document.getElementById('checkoutBtn');
                checkoutBtn.disabled = selectedCount === 0;
                checkoutBtn.style.backgroundColor = selectedCount === 0 ? '#ccc' : '#4CAF50';
            }

            // Chọn/bỏ chọn tất cả
            function toggleSelectAll() {
                var selectAllCheckbox = document.getElementById('selectAll');
                var itemCheckboxes = document.querySelectorAll('.item-checkbox');

                itemCheckboxes.forEach(function (checkbox) {
                    checkbox.checked = selectAllCheckbox.checked;
                });

                updateSelectedTotal();
            }

            // Kiểm tra trạng thái "Chọn tất cả"
            function checkSelectAllStatus() {
                var itemCheckboxes = document.querySelectorAll('.item-checkbox');
                var checkedCheckboxes = document.querySelectorAll('.item-checkbox:checked');
                var selectAllCheckbox = document.getElementById('selectAll');

                if (itemCheckboxes.length === 0) {
                    selectAllCheckbox.checked = false;
                    selectAllCheckbox.disabled = true;
                } else {
                    selectAllCheckbox.disabled = false;
                    selectAllCheckbox.checked = itemCheckboxes.length === checkedCheckboxes.length;
                }

                updateSelectedTotal();
            }

            // Xử lý checkout với sản phẩm được chọn
            function checkoutSelected() {
                var checkboxes = document.querySelectorAll('.item-checkbox:checked');
                if (checkboxes.length === 0) {
                    alert('Please select at least one product to checkout!');
                    return false;
                }

                // Tạo form với các sản phẩm được chọn
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'checkout?action=showSelected';

                checkboxes.forEach(function (checkbox) {
                    var input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'selectedItems';
                    input.value = checkbox.value;
                    form.appendChild(input);
                });

                document.body.appendChild(form);
                form.submit();
            }

            window.onload = function () {
                checkSelectAllStatus();
            }
        </script>
    </head>
    <body>
        <h1>My cart</h1>

        <%
            // Lấy cart từ request attribute
            Cart cart = (Cart) request.getAttribute("cart");
        
            // Hiển thị thông báo lỗi nếu có
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div style="color: red; margin-bottom: 10px;">
            <strong>Error: </strong><%= error %>
        </div>
        <%
            }
        
            // Hiển thị thông báo thành công nếu có
            String success = (String) request.getAttribute("success");
            if (success != null) {
        %>
        <div style="color: green; margin-bottom: 10px;">
            <strong>Succeed: </strong><%= success %>
        </div>
        <%
            }
        
            // Hiển thị thông báo success từ session
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
        %>
        <div style="color: green; margin-bottom: 10px;">
            <strong>Succeed: </strong><%= successMessage %>
        </div>
        <%
                session.removeAttribute("successMessage");
            }
            
            // Hiển thị thông báo error từ session
            String errorMessage = (String) session.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <div style="color: red; margin-bottom: 10px;">
            <strong>Error: </strong><%= errorMessage %>
        </div>
        <%
                session.removeAttribute("errorMessage");
            }
            
            // Hiển thị cảnh báo tồn kho
            List<String> inventoryErrors = (List<String>) session.getAttribute("inventoryErrors");
            if (inventoryErrors != null && !inventoryErrors.isEmpty()) {
        %>
        <div style="color: red; margin-bottom: 10px;">
            <strong>Inventory Alert:</strong>
            <ul>
                <% for (String inventoryError : inventoryErrors) { %>
                <li><%= inventoryError %></li>
                    <% } %>
            </ul>
        </div>
        <%
                session.removeAttribute("inventoryErrors");
            }
        
            // Kiểm tra giỏ hàng có trống không
            if (cart == null || cart.isEmpty()) {
        %>    
        <div>
            <h3>Your cart is empty</h3>
            <p><a href="productList.jsp">Continue shopping</a></p>
        </div>
        <%
            } else {
                List<CartItem> items = cart.getItems();
        %>
        <div>
            <p>Total products: <strong><%= cart.getTotalQuantity() %></strong></p>
            <p>Total amount: <strong><%= String.format("%.2f", cart.getTotalAmount()) %> $</strong></p>
        </div>


        <div style="background-color: #f0f8ff; padding: 10px; margin: 10px 0; border: 1px solid #ddd;">
            <strong>Selected: <span id="selectedCount">0</span> products | Total: <span id="selectedTotal">0.00 $</span></strong>
        </div>

        <table border="1" cellpadding="5" cellspacing="0" width="100%">
            <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                        Select all
                    </th>                    
                    <th>No.</th>
                    <th>Product Name</th>
                    <th>Type</th>
                    <th>Unit price</th>
                    <th>Quantity</th>
                    <th>Total amount</th>
                    <th>Active</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int index = 1;
                    for (CartItem item : items) {
                        // Kiểm tra trạng thái tồn kho
                        boolean isOutOfStock = item.getAvailableQuantity() <= 0;
                        boolean isLowStock = item.getAvailableQuantity() > 0 && item.getAvailableQuantity() < item.getQuantity();
                        boolean itemExists = item.isItemExists();
                        
                        String rowClass = "";
                        if (!itemExists || isOutOfStock) {
                            rowClass = "out-of-stock";
                        }
                %>
                <tr class="<%= rowClass %>">
                    <td>
                        <input type="checkbox" class="item-checkbox" 
                               value="<%= item.getItemType() %>_<%= item.getItemId() %>"
                               onchange="checkSelectAllStatus()"
                               <%= (!itemExists || isOutOfStock) ? "disabled" : "" %>>
                    </td>
                    <td><%= index++ %></td>
                    <td>
                        <%= item.getItemName() %>
                        <% if (!itemExists) { %>
                        <br>(Product does not exist)
                        <% } else if (isOutOfStock) { %>
                        <br>(Out of stock)
                        <% } %>
                    </td>
                    <td>
                        <%= "MODEL".equals(item.getItemType()) ? "Car Model" : "Accessory" %>
                    </td>
                    <td><%= String.format("%.2f", item.getUnitPrice()) %> $</td>
                    <td>
                        <% if (!itemExists || isOutOfStock) { %>
                        <span style="color: red;"><%= item.getQuantity() %></span>
                        <% } else { %>
                        <form action="cart" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="itemType" value="<%= item.getItemType() %>">
                            <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                            <input type="number" name="quantity" value="<%= item.getQuantity() %>" 
                                   min="0" max="100000" style="width: 60px;">
                            <input type="submit" value="Update">
                        </form>
                        <% } %>
                    </td>
                    <td class="subtotal"><%= String.format("%.2f", item.getSubTotal()) %> $</td>
                    <td>

                        <a href="cart?action=remove&itemType=<%= item.getItemType() %>&itemId=<%= item.getItemId() %>"
                           onclick="return confirm('Are you sure you want to delete this product?')">
                            Delete
                        </a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <div style="margin-top: 20px;">
            <h3>Total all products: <%= String.format("%.2f", cart.getTotalAmount()) %> $</h3>
        </div>

        <div style="margin-top: 20px;">
            <a href="cart?action=clear" 
               onclick="return confirm('Are you sure you want to delete the entire cart?')"
               style="color: red;">
                Clear entire cart
            </a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="productList.jsp">Continue shopping</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <button id="checkoutBtn" onclick="checkoutSelected()" 
                    style="background-color: #ccc; color: white; padding: 10px 20px; border: none; cursor: pointer;"
                    disabled>
                Pay selected products
            </button>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="checkout?action=show" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none;">
                Pay all products
            </a>
        </div>
        <%
            }
        %>

        <br><br>
        <a href="home.jsp">Back to home page</a>
    </body>
</html>