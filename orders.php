<?php
require_once 'db_connect.php';
require_once 'navigation.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Orders</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="container center-content">
    <h1>Orders</h1>
    <h2>Order Count by Date</h2>
    <table>
        <tr>
            <th>Date</th>
            <th>Number of Orders</th>
        </tr>
        <?php
        $ordersByDate = $pdo->query("SELECT OrderDate, COUNT(OrderID) as OrderCount FROM CustomerOrder GROUP BY OrderDate");
        while ($order = $ordersByDate->fetch(PDO::FETCH_ASSOC)) {
            echo '<tr><td>' . $order['OrderDate'] . '</td><td>' . $order['OrderCount'] . '</td></tr>';
        }
        ?>
    </table>

    <h2>Orders on a Specific Date</h2>
    <form action="" method="POST">
        <label for="date">Select a date:</label>
        <input type="date" id="date" name="date">
        <button type="submit" name="submit">Show Orders</button>
    </form>
    <?php
    if (isset($_POST['submit'])) {
        $selectedDate = $_POST['date'];
        echo '<h3>Orders on ' . $selectedDate . '</h3>';
        $ordersOnDate = $pdo->prepare("SELECT CO.OrderID, CA.FirstName, CA.LastName, CO.TotalPrice, CO.Tip, E.FirstName as DeliveryFirstName, E.LastName as DeliveryLastName
            FROM CustomerOrder CO
            JOIN CustomerAcct CA ON CO.CustEmail = CA.Email
            JOIN Delivery D ON CO.DeliveredBy = D.EmID
            JOIN Employee E ON D.EmID = E.EmployeeID
            WHERE CO.OrderDate = :selectedDate");
        $ordersOnDate->execute(['selectedDate' => $selectedDate]);
        
        echo '<table>';
        echo '<tr><th>Order ID</th><th>Customer Name</th><th>Total Price</th><th>Tip</th><th>Delivered By</th><th>Items</th></tr>';
        while ($order = $ordersOnDate->fetch(PDO::FETCH_ASSOC)) {
            echo '<tr>';
            echo '<td>' . $order['OrderID'] . '</td>';
            echo '<td>' . $order['FirstName'] . ' ' . $order['LastName'] . '</td>';
            echo '<td>$' . $order['TotalPrice'] . '</td>';
            echo '<td>$' . $order['Tip'] . '</td>';
            echo '<td>' . $order['DeliveryFirstName'] . ' ' . $order['DeliveryLastName'] . '</td>';

            $orderItems = $pdo->prepare("SELECT FoodName, Quantity FROM OrderContainsFood WHERE OrderID = :orderID");
            $orderItems->execute(['orderID' => $order['OrderID']]);
            echo '<td><ul>';
            while ($item = $orderItems->fetch(PDO::FETCH_ASSOC)) {
                echo '<li>' . $item['FoodName'] . ' (x' . $item['Quantity'] . ')</li>';
            }
            echo '</ul></td>';
            echo '</tr>';
        }
        echo '</table>';
    }
    ?>
</div>
</body>
</html>
