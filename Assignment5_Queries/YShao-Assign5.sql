-- How many containers of antibiotics are currently available?
SELECT quantityOnHand
FROM item
WHERE itemDescription = 'bottle of antibiotics';

-- Which volunteer(s), if any, have phone numbers that do not start with the number 2 and whose
-- last name is not Jones. Query should retrieve names rather than ids.
SELECT volunteerName
FROM volunteer
WHERE volunteerTelephone IS NOT NULL AND volunteerTelephone NOT LIKE '2%' AND volunteerName NOT LIKE '% Jones';

-- Which volunteer(s) are working on transporting tasks? Query should retrieve names rather than ids.
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
JOIN assignment ON volunteer.volunteerId = assignment.volunteerId
JOIN task ON assignment.taskCode = task.taskCode
JOIN task_type ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName = 'transporting';

-- Which task(s) have yet to be assigned to any volunteers (provide task descriptions, not the codes)?
SELECT task.taskDescription
FROM task
LEFT JOIN assignment ON task.taskCode = assignment.taskCode
WHERE assignment.taskCode IS NULL;

-- Which type(s) of package contain some kind of bottle?
SELECT DISTINCT package_type.packageTypeName
FROM package_type
JOIN package ON package_type.packageTypeId = package.packageTypeId
JOIN package_contents ON package.packageId = package_contents.packageId
JOIN item ON package_contents.itemId = item.itemId
WHERE item.itemDescription LIKE '%bottle%';

-- Which items, if any, are not in any packages? Answer should be item descriptions.
SELECT item.itemDescription
FROM item
LEFT JOIN package_contents ON item.itemId = package_contents.itemId
WHERE package_contents.packageId IS NULL;

-- Which task(s) are assigned to volunteer(s) that live in New Jersey (NJ)? Answer should have the
-- task description and not the task ids.
SELECT DISTINCT task.taskDescription
FROM task
JOIN assignment ON task.taskCode = assignment.taskCode
JOIN volunteer ON assignment.volunteerId = volunteer.volunteerId
WHERE volunteer.volunteerAddress LIKE '%NJ';

-- Which volunteers began their assignments in the first half of 2021? Answer should have the
-- volunteer names and not their ids.
SELECT volunteer.volunteerName
FROM volunteer
JOIN assignment ON volunteer.volunteerId = assignment.volunteerId
WHERE assignment.startDateTime >= '2021-01-01' AND assignment.startDateTime < '2021-07-01';

-- Which volunteers have been assigned to tasks that include packing spam? Answer should have the
-- volunteer names and not their ids.
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
JOIN assignment ON volunteer.volunteerId = assignment.volunteerId
JOIN package ON assignment.taskCode = package.taskCode
JOIN package_contents ON package.packageId = package_contents.packageId
JOIN item ON package_contents.itemId = item.itemId
WHERE item.itemDescription = 'can of spam';

-- Which item(s) (if any) have a total value of exactly $100 in one package? Answer should be item
-- descriptions.
SELECT DISTINCT item.itemDescription
FROM item
JOIN package_contents ON item.itemId = package_contents.itemId
WHERE item.itemValue * package_contents.itemQuantity = 100;

-- How many volunteers are assigned to tasks with each different status? The answer should show
-- each different status and the number of volunteers sorted from highest to lowest.
SELECT task_status.taskStatusName, COUNT(DISTINCT assignment.volunteerId) AS volunteerCount
FROM task_status
JOIN task ON task_status.taskStatusId = task.taskStatusId
JOIN assignment ON task.taskCode = assignment.taskCode
GROUP BY task_status.taskStatusId, task_status.taskStatusName
ORDER BY volunteerCount DESC;

-- Which task creates the heaviest set of packages and what is the weight? Show both the taskCode
-- and the weight (You should be able to do this without using any sub-queries).
SELECT taskCode, SUM(packageWeight) AS totalWeight
FROM package
GROUP BY taskCode
ORDER BY totalWeight DESC
LIMIT 1;

-- How many tasks are there that do not have a type of "packing"?
SELECT COUNT(*)
FROM task
JOIN task_type ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName != 'packing';

-- Of those items that have been packed, which item (or items) were touched by fewer than 3
-- volunteers? Answer should be item descriptions.
SELECT item.itemDescription
FROM item
JOIN package_contents ON item.itemId = package_contents.itemId
JOIN package ON package_contents.packageId = package.packageId
LEFT JOIN assignment ON package.taskCode = assignment.taskCode
GROUP BY item.itemId, item.itemDescription
HAVING COUNT(DISTINCT assignment.volunteerId) < 3;

-- Which packages have a total value of more than 100? Show the packageIds and their value sorted
-- from lowest to highest.
SELECT package_contents.packageId, SUM(package_contents.itemQuantity * item.itemValue) AS totalValue
FROM package_contents
JOIN item ON package_contents.itemId = item.itemId
GROUP BY package_contents.packageId
HAVING SUM(package_contents.itemQuantity * item.itemValue) > 100
ORDER BY totalValue ASC;

