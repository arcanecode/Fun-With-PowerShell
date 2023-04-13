using System;

public class StaticSchemaTableInFile
{
  public static string FullName(string pSchema, string pTable)
  {
    string retVal = "";

    retVal = pSchema + "." + pTable;

    return retVal;

  } // public static FullName
} // class StaticSchemaTableInFile
