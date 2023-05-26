/*
 * $Id: exmemo.prg 9548 2008-10-05 13:57:35Z vszakats $
 */

REQUEST DBTCDX
REQUEST FPTCDX
REQUEST SMTCDX

PROCEDURE MAIN()

   DBCREATE("table1", {{"F1","M",4,0}}, "DBTCDX")
   DBCREATE("table2", {{"F1","M",4,0}}, "FPTCDX")
   DBCREATE("table3", {{"F1","M",4,0}}, "SMTCDX")

   RETURN
