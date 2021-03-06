# SearchBar to Demonsrate Auto Layout with Optional Constraints and Inequalities
Even if an optional constraint cannot be satisfied, it can still influence the layout. If there is any ambiguity in the layout after skipping the constraint, the system selects the solution that comes closest to the constraint. In this way, unsatisfied optional constraints act as a force pulling views towards them.
Don’t feel obligated to use all 1000 priority values. In fact, priorities should general cluster around the system-defined low (250), medium (500), high (750), and required (1000) priorities. You may need to make constraints that are one or two points higher or lower than these values, to help prevent ties. If you’re going much beyond that, you probably want to reexamine your layout’s logic.
-- Auto Layout Guide by Apple

iOS 12.2 (16E227), Version 10.2.1 (10E1001)

![screen shot](https://user-images.githubusercontent.com/27608286/57174099-266cc600-6e07-11e9-9a2f-3a615c74d2ca.png)
