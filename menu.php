<?php require_once('db_connect.php'); ?>
<!DOCTYPE html>
<html>
<head>
    <title>Menu</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <?php require_once('navigation.php'); ?>
    <div class="main-section">
        <h1>Menu</h1>
        <?php
        $stmt = $pdo->prepare("SELECT Category FROM Food JOIN FoodRestaurant ON Food.Name = FoodRestaurant.FoodName WHERE FoodRestaurant.RestName = :restaurant GROUP BY Category");
        $stmt->execute(array(':restaurant' => 'Rollin Burritos'));

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $category = $row['Category'];
            echo "<h2>$category</h2>";
            $menuItemsStmt = $pdo->prepare("SELECT Food.Name, FoodRestaurant.Price FROM Food JOIN FoodRestaurant ON Food.Name = FoodRestaurant.FoodName WHERE FoodRestaurant.RestName = :restaurant AND Food.Category = :category");
            $menuItemsStmt->execute(array(':restaurant' => 'Rollin Burritos', ':category' => $category));
            echo "<ul>";
            while ($menuItemRow = $menuItemsStmt->fetch(PDO::FETCH_ASSOC)) {
                $name = $menuItemRow['Name'];
                $price = $menuItemRow['Price'];
                echo "<li>$name - $$price</li>";
            }
            echo "<ul class='no-bullets'>";
        }
        ?>
    </div>
</body>
</html>

