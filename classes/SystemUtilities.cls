/*
Author: Kshitij Lawate

Permission is hereby granted, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction.

*Class Details*
Class with resusable utilities to use within any apex class in system
*/
public class SystemUtilities
{
    //map with sobject name as key and sobject type as value 
    static Map<String,Schema.SObjectType> globalDescribe;
    //map wth object name as Key and Sobject describe result as value 
    static Map<String, Schema.DescribeSObjectResult> mapSobjNameToObjDescribe = new Map<String, Schema.DescribeSObjectResult>();

    /**
     * method to perform describe sobject only once in a transaction and return it from static variable on multiple calls
     */
    public static Map<String,Schema.SObjectType> getGlobalDescribe()
    {
      if(globalDescribe == null)
      {
        globalDescribe = Schema.getGlobalDescribe(); 
      }
      return globalDescribe;
    }

    /**
     * method that accepts sobject name as parameter and returns sobject describe result
     */
    public static Schema.DescribeSObjectResult getSobjectDescribe(String mapSobjName)
    {
        Schema.DescribeSObjectResult dsResult;

        if(!mapSobjNameToObjDescribe.containsKey(mapSobjName))
        {
            Map<String,Schema.SObjectType> mapGD = getGlobalDescribe();
            if(mapGD.containsKey(mapSobjName))
            {
                dsResult = mapGD.get(mapSobjName).getDescribe();
                mapSobjNameToObjDescribe.put(mapSobjName, dsResult);
            }
        }
        else 
        {
            dsResult = mapSobjNameToObjDescribe.get(mapSobjName);  
        }
        return dsResult;
    }
    /**
     * method to fetch value dynamically based on sobject instance and fieldAPI passed in parameter. the Field API can be value traversing accross 
     * parent objects
     */
    public static object fetchFieldValue (Sobject sobjRec, String fieldApi)
    {
      Object returnValue;
      Sobject sobj = sobjRec.clone(true, true, false, false);
      String sobjFieldApi = fieldApi;

      while (sobjFieldApi.contains('.'))
      {
        List<String> lstSobjFields = sobjFieldApi.split('\\.', 2);
        sobj = sobj.getSobject(lstSobjFields[0]);
        sobjFieldApi = lstSobjFields[1];
      }
      if(sobj != null)
      {
        returnValue = sobj.get(sobjFieldApi);
      }

      return returnValue;
    }
    
    /**
     * method to populate field values in formatted string e.g. This {0} is a formmated {1} string. The {0} and {1} will be replaced with field values 
     */
    public static String populateFormattedString (String formattedString, Sobject sobjRec, List<String> lstFieldApis)
    {
      String fieldMergedString ;

      List<String> lstFieldValues = new List<String>();

      for(String fieldApi : lstFieldApis)
      {
        Object fieldValue = fetchFieldValue(sobjRec, fieldApi);
        String strFieldValue;

        if(fieldValue instanceOf DateTime)
        {
          strFieldValue = ((DateTime)fieldValue).format();
        }
        else if(fieldValue instanceOf Date)
        {
          strFieldValue = ((Date)fieldValue).format();
        }
        else 
        {
          strFieldValue = String.valueOf(fieldValue);
        }

        lstFieldValues.add(strFieldValue);
      }

      fieldMergedString = String.format(formattedString, lstFieldValues);

      return fieldMergedString;
    }
}