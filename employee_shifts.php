<?php
require_once 'db_connect.php';
require_once 'navigation.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Employee Schedule</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="container center-content">
    <h1>Employee Schedule</h1>
    <form action="" method="POST">
        <label for="employee">Select an employee:</label>
        <select name="employee" id="employee">
            <?php
            $employees = $pdo->query("SELECT EmployeeID, FirstName, LastName FROM Employee ORDER BY LastName, FirstName");
            while ($employee = $employees->fetch(PDO::FETCH_ASSOC)) {
                echo '<option value="' . $employee['EmployeeID'] . '">' . $employee['FirstName'] . ' ' . $employee['LastName'] . '</option>';
            }
            ?>
        </select>
        <button type="submit" name="submit">Show Schedule</button>
    </form>
    <?php
    if (isset($_POST['submit'])) {
        $employeeID = $_POST['employee'];
        $selectedEmployee = $pdo->prepare("SELECT FirstName, LastName FROM Employee WHERE EmployeeID = :employeeID");
        $selectedEmployee->execute(['employeeID' => $employeeID]);
        $employeeName = $selectedEmployee->fetch(PDO::FETCH_ASSOC);
        echo '<h2>' . $employeeName['FirstName'] . ' ' . $employeeName['LastName'] . '\'s Schedule</h2>';
        $schedule = $pdo->prepare("SELECT ShiftDate, StartTime, EndTime FROM Shift WHERE EmID = :employeeID AND WEEKDAY(ShiftDate) NOT IN (5, 6) ORDER BY ShiftDate, StartTime");
        $schedule->execute(['employeeID' => $employeeID]);
        echo '<table>';
        echo '<tr><th>Date</th><th>Start Time</th><th>End Time</th><th>Day of Week</th></tr>';
        $daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
        while ($shift = $schedule->fetch(PDO::FETCH_ASSOC)) {
            $dayOfWeek = $daysOfWeek[date('N', strtotime($shift['ShiftDate'])) - 1];
            echo '<tr><td>' . $shift['ShiftDate'] . '</td><td>' . $shift['StartTime'] . '</td><td>' . $shift['EndTime'] . '</td><td>' . $dayOfWeek . '</td></tr>';
        }
        echo '</table>';
    }
    ?>
</div>
</body>
</html>
