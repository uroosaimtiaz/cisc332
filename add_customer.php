<?php
require_once('db_connect.php');

$message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $firstName = $_POST['firstName'];
    $lastName = $_POST['lastName'];
    $email = $_POST['email'];
    $cellNum = $_POST['cellNum'];
    $street = $_POST['street'];
    $city = $_POST['city'];
    $postalCode = $_POST['postalCode'];
    $credit = 5;

    $checkEmailStmt = $pdo->prepare("SELECT Email FROM CustomerAcct WHERE Email = :email");
    $checkEmailStmt->execute([':email' => $email]);

    if ($checkEmailStmt->fetch()) {
        $message = "This email already exists in the database.";
    } else {
        $insertStmt = $pdo->prepare("INSERT INTO CustomerAcct (Email, FirstName, LastName, CellNum, Street, City, PostalCode, Credit) VALUES (:email, :firstName, :lastName, :cellNum, :street, :city, :postalCode, :credit)");
        $insertStmt->execute([':email' => $email, ':firstName' => $firstName, ':lastName' => $lastName, ':cellNum' => $cellNum, ':street' => $street, ':city' => $city, ':postalCode' => $postalCode, ':credit' => $credit]);
        $message = "New customer added successfully!";
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Add Customer</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <?php require_once('navigation.php'); ?>
    <div class="main-section">
        <h1>Add New Customer</h1>
        <?php if($message): ?>
            <p><?= $message ?></p>
        <?php endif; ?>
        <form method="POST" action="add_customer.php">
            <label>First Name: <input type="text" name="firstName" required></label><br>
            <label>Last Name: <input type="text" name="lastName" required></label><br>
            <label>Email: <input type="email" name="email" required></label><br>
            <label>Cell Number: <input type="text" name="cellNum" required></label><br>
            <label>Street: <input type="text" name="street" required></label><br>
            <label>City: <input type="text" name="city" required></label><br>
            <label>Postal Code: <input type="text" name="postalCode" required></label><br>
            <button type="submit">Add Customer</button>
        </form>
    </div>
</body>
</html>
